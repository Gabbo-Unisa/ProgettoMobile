import 'package:flutter/material.dart';

class RicercaProvider with ChangeNotifier {
  String _query = '';

  String get query => _query;

  void aggiornaQuery(String nuovaQuery) {
    _query = nuovaQuery;
    notifyListeners();
  }
}