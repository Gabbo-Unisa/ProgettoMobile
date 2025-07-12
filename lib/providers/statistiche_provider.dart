import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class StatisticheProvider extends ChangeNotifier {
  int totaleVinili = 0;
  Map<String, int> viniliPerCategoria = {};
  List<String> viniliPiuVecchi = [];
  Map<String, int> crescitaAnnuale = {};

  Future<void> caricaStatistiche() async {
    final db = await DatabaseHelper.instance.database;

    // Totale vinili
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as totale FROM vinili',
    );
    totaleVinili = countResult.first['totale'] as int? ?? 0;

    // Vinili per categoria (inclusi quelli senza categoria)
    final categoriaResult = await db.rawQuery('''
      SELECT
        COALESCE(c.nome, 'Senza categoria') as categoria,
        COUNT(v.id) as totale
      FROM vinili v
      LEFT JOIN categorie c ON v.categoriaId = c.id
      GROUP BY categoria
      ''');
    viniliPerCategoria = {
      for (var row in categoriaResult)
        row['categoria'] as String: row['totale'] as int,
    };

    // Vinili più vecchi (fino a 3)
    final vecchiResult = await db.rawQuery('''
      SELECT titolo, anno
      FROM vinili
      WHERE anno IS NOT NULL
      ORDER BY anno ASC
      LIMIT 3
      ''');
    viniliPiuVecchi =
        vecchiResult.map((e) => '${e['titolo']} (${e['anno']})').toList();

    // Crescita annua (vinili aggiunti per anno)
    final crescitaResult = await db.rawQuery('''
      SELECT strftime('%Y', dataAggiunta) as anno, COUNT(*) as totale
      FROM vinili
      WHERE dataAggiunta IS NOT NULL
      GROUP BY strftime('%Y', dataAggiunta)
      ORDER BY strftime('%Y', dataAggiunta) ASC
      ''');
    crescitaAnnuale = {
      for (var row in crescitaResult)
        row['anno'] as String: row['totale'] as int,
    };

    notifyListeners();
  }
}
