import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/vinile_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/ricerca_provider.dart';
import 'providers/statistiche_provider.dart';

import 'screens/schermata_principale.dart';
import 'screens/schermata_categorie.dart';
import 'screens/schermata_profilo.dart';
import 'theme/app_theme.dart';

import 'screens/form_vinile.dart';
//import 'package:sqflite/sqflite.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await resetDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VinileProvider()),
        ChangeNotifierProvider(create: (_) => CategoriaProvider()),
        ChangeNotifierProvider(create: (_) => RicercaProvider()),
        ChangeNotifierProvider(create: (_) => StatisticheProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/*
Future<void> resetDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = '$dbPath/vinyl_collection.db';
  await deleteDatabase(path);
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinylVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const VistaTabs(title: 'VinylVault'),
    );
  }
}

class VistaTabs extends StatefulWidget {
  const VistaTabs({super.key, required this.title});

  final String title;

  @override
  State<VistaTabs> createState() => _VistaTabsState();
}

class _VistaTabsState extends State<VistaTabs> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    SchermataPrincipale(),
    SchermataCategorie(),
    SchermataProfilo(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.library_add), label: 'Categorie'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _selectedIndex == 2 ? null : AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/VinylVault.png',
              height: 50,
              width: 50,
            ),
            Text(widget.title),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Ricerca',
            onPressed: () {
                //implementare ricerca
            },
          ),
        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      floatingActionButton: _selectedIndex == 2 ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SchermataAggiuntaVinile()));
        },
        backgroundColor: Color(0xFF001237),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}