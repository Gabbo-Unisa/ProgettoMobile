import 'package:flutter/material.dart';
import '../models/vinile.dart';

class RicercaProvider with ChangeNotifier {
  List<Vinile> _vinili = [];
  List<Vinile> _risultati = [];
  List<String> _suggerimenti = [];

  List<Vinile> get risultati => _risultati;
  List<String> get suggerimenti => _suggerimenti;

  void impostaVinili(List<Vinile> vinili) {
    _vinili = vinili;
    _risultati = vinili;
    _suggerimenti = [];
  }

  void aggiornaRicerca(String query) {
    final q = query.toLowerCase();

    _risultati =
        _vinili.where((v) {
          return v.titolo.toLowerCase().contains(q);
        }).toList();

    if (q.isEmpty) {
      _risultati = _vinili;
      _suggerimenti = [];
    }
    _suggerimenti =
        _vinili
            .map((v) => '${v.titolo}')
            .where((s) => s.toLowerCase().contains(q))
            .take(3)
            .toList();

    if (q.isEmpty) {
      _risultati = _vinili;
      _suggerimenti = [];
    }

    notifyListeners();
  }

  void applicaSuggerimento(String valore) {
    aggiornaRicerca(valore);
    _suggerimenti = []; // nascondi suggerimenti
    notifyListeners();
  }
}
