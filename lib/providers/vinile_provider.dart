import 'package:flutter/material.dart';
import '../models/vinile.dart';
import '../db/database_helper.dart';

class VinileProvider with ChangeNotifier {
  List<Vinile> _vinili = [];

  List<Vinile> get vinili => _vinili;

  Future<void> caricaVinili() async {
    _vinili = await DatabaseHelper.instance.getVinili();
    notifyListeners();
  }

  // Restituisce i vinili più recenti basandosi sugli ID (più alti = più recenti)
  List<Vinile> getViniliRecenti({int limite = 5}) {
    final validi =
        _vinili.where((v) => v.dataAggiunta != null && v.id != null).toList();

    validi.sort((a, b) {
      final cmpData = b.dataAggiunta!.compareTo(a.dataAggiunta!);
      if (cmpData != 0) return cmpData;

      // In caso di stessa data, ordina per id decrescente
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });

    return validi.take(limite).toList();
  }

  // Restituisce una selezione casuale di vinili che NON siano tra i più recenti (se possibile)
  List<Vinile> getViniliCasuali({int limite = 3}) {
    final recenti = getViniliRecenti();
    final idRecenti = recenti.map((v) => v.id).toSet();

    final nonRecenti = _vinili.where((v) => !idRecenti.contains(v.id)).toList();

    // Se ci sono abbastanza vinili che non rientrano nei recenti, selezioniamo 'limite' elementi casuali
    if (nonRecenti.length >= limite) {
      nonRecenti.shuffle();
      return nonRecenti.take(limite).toList();
    }

    // Altrimenti, se non ci sono abbastanza vinili che non rientrano nei recenti, inseriamo i restanti vinili dai recenti
    final copiaNonRecenti = [...nonRecenti];
    final copiaRecenti = [...recenti];

    copiaNonRecenti.shuffle();
    copiaRecenti.shuffle();

    // Combiniamo prima i non-recenti e poi i recenti
    final combinati = [...copiaNonRecenti, ...copiaRecenti];
    return combinati.take(limite).toList();
  }

  Future<void> aggiungiVinile(Vinile v) async {
    await DatabaseHelper.instance.insertVinile(v);
    await caricaVinili();
  }

  Future<void> eliminaVinile(int id) async {
    await DatabaseHelper.instance.deleteVinile(id);
    await caricaVinili();
  }

  Future<void> aggiornaVinile(Vinile v) async {
    await DatabaseHelper.instance.updateVinile(v);
    await caricaVinili();
  }
}
