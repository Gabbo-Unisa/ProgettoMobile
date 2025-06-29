import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class StatisticheProvider with ChangeNotifier {
  int _preferiti = 0;

  int get preferiti => _preferiti;

  Future<void> aggiornaPreferiti() async {
    final vinili = await DatabaseHelper.instance.getVinili();
    _preferiti = vinili.where((v) => v.preferito).length;
    notifyListeners();
  }
}