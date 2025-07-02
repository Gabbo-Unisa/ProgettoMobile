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