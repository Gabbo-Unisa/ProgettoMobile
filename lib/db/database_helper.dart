import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/vinile.dart';
import '../models/categoria.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'vinyl_collection.db'),
      version: 1,
      onConfigure: _onConfigure,
      onCreate: (db, version) async {
        // Creazione tabella categorie
        await db.execute('''
          CREATE TABLE categorie (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL
          )
        ''');

        // Creazione tabella vinili
        await db.execute('''
          CREATE TABLE vinili (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titolo TEXT NOT NULL,
            artista TEXT NOT NULL,
            anno INTEGER,
            etichetta TEXT,
            condizione TEXT,
            copertina TEXT,
            preferito INTEGER NOT NULL,
            note TEXT,
            categoriaId INTEGER,
            FOREIGN KEY (categoriaId) REFERENCES categorie(id) ON DELETE SET NULL
          )
        ''');
      },
    );
  }

  // ----------------------------
  // METODI CRUD VINILI
  // ----------------------------

  Future<void> insertVinile(Vinile vinile) async {
    final db = await database;
    await db.insert(
      'vinili',
      vinile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Vinile>> getVinili() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vinili');
    return List.generate(maps.length, (i) => Vinile.fromMap(maps[i]));
  }

  Future<void> updateVinile(Vinile vinile) async {
    final db = await database;
    await db.update(
      'vinili',
      vinile.toMap(),
      where: 'id = ?',
      whereArgs: [vinile.id],
    );
  }

  Future<void> deleteVinile(int id) async {
    final db = await database;
    await db.delete('vinili', where: 'id = ?', whereArgs: [id]);
  }

  // ----------------------------
  // METODI CRUD CATEGORIE
  // ----------------------------

  Future<void> insertCategoria(Categoria categoria) async {
    final db = await database;
    await db.insert(
      'categorie',
      categoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Categoria>> getCategorie() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categorie');
    return List.generate(maps.length, (i) => Categoria.fromMap(maps[i]));
  }

  Future<void> deleteCategoria(int id) async {
    final db = await database;
    await db.delete('categorie', where: 'id = ?', whereArgs: [id]);
  }
}
