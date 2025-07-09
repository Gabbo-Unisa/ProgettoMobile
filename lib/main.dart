import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'db/database_helper.dart';
import 'providers/vinile_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/ricerca_provider.dart';
import 'providers/statistiche_provider.dart';

import 'screens/home.dart';
import 'screens/libreria.dart';
import 'screens/statistiche.dart';
import 'screens/ricerca.dart';
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
      home: SafeArea(child: const VistaTabs(title: 'VinylVault')),
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
    SchermataLibreria(),
    SchermataStatistiche(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      await Provider.of<StatisticheProvider>(
        context,
        listen: false,
      ).caricaStatistiche();
    }
    setState(() => _selectedIndex = index);
  }

  static final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(MdiIcons.bookshelf), label: 'Libreria'),
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.chartArc),
      label: 'Statistiche',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBar visibile solo in "Home" e "Libreria"
          _selectedIndex == 2
              ? null
              : AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Icona app
                    Image.asset(
                      'assets/images/VinylVault.png',
                      height: 50,
                      width: 50,
                    ),
                    // Nome app
                    Text(widget.title),
                  ],
                ),
                actions: <Widget>[
                  // Ricerca
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    tooltip: 'Ricerca',
                    onPressed: () {
                      // Recupero tutti i vinili
                      final vinili =
                          Provider.of<VinileProvider>(
                            context,
                            listen: false,
                          ).vinili;
                      // Imposto i vinili nel provider di ricerca
                      Provider.of<RicercaProvider>(
                        context,
                        listen: false,
                      ).impostaVinili(vinili);
                      // Vai alla schermata di ricerca
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SchermataRicerca(),
                        ),
                      );
                    },
                  ),
                ],
              ),

      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      floatingActionButton:
          _selectedIndex == 2
              ? null
              : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchermataAggiuntaVinile(),
                    ),
                  );
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
