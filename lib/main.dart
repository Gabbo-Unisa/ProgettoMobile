import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/vinile_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/ricerca_provider.dart';
import 'providers/statistiche_provider.dart';

import 'screens/schermata_principale.dart';
import 'screens/schermata_categorie.dart';
import 'screens/schermata_profilo.dart';

void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinylVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF001237),
        scaffoldBackgroundColor: const Color(0xFF000B23),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white60),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.lightBlueAccent,
          selectionHandleColor: Colors.lightBlueAccent,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.selected)) {
                  return Colors.lightBlueAccent;
              }
              return Colors.white24;
            },
          ),
          trackColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.lightBlue.withOpacity(0.5);
              }
              return Colors.white10;
            },
          ),
        ),
      ),
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

      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/VinylVault.png',
              height: 50,
              width: 50,
            ),
            Text(widget.title),
            const SizedBox(width: 10),
          ],
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFF000B23),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 25),
            tooltip: 'Ricerca',
            onPressed: () {

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
        backgroundColor: const Color(0xFF000B23),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}