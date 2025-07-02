import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../db/database_helper.dart';

class CategoriaProvider with ChangeNotifier {
  List<Categoria> _categorie = [];

  List<Categoria> get categorie => _categorie;

  Future<void> caricaCategorie() async {
    _categorie = await DatabaseHelper.instance.getCategorie();
    notifyListeners();
  }

  Future<void> aggiungiCategoria(Categoria c) async {
    await DatabaseHelper.instance.insertCategoria(c);
    await caricaCategorie();
  }

  Future<void> eliminaCategoria(int id) async {
    await DatabaseHelper.instance.deleteCategoria(id);
    await caricaCategorie();
  }
}