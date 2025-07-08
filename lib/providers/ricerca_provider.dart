import 'package:flutter/material.dart';
import '../models/vinile.dart';

class RicercaProvider with ChangeNotifier {
  List<Vinile> _vinili = [];
  List<Vinile> _risultati = [];

  List<Vinile> get risultati => _risultati;

  void impostaVinili(List<Vinile> vinili) {
    _vinili = vinili;
    _risultati = vinili;
  }

  void aggiornaRicerca(String query) {
    final q = query.toLowerCase();
    _risultati =
        _vinili
            .where(
              (v) =>
                  v.titolo.toLowerCase().contains(q) ||
                  v.artista.toLowerCase().contains(q),
            )
            .toList();
    notifyListeners();
  }
}
