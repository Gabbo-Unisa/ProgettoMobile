import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/vinile_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/ricerca_provider.dart';
import 'providers/statistiche_provider.dart';
/*import 'screens/schermata_principale.dart';
import 'screens/schermata_categorie.dart';
import 'screens/BarraSopra.dart';*/

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
      title: 'Vinyl Collection',
      debugShowCheckedModeBanner: false,
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
  List<int> list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            /*scrolledUnderElevation: 4,*/
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
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            backgroundColor: const Color(0xFF001237),

            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              tabs: [
                Tab(icon: Icon(Icons.home), text: "Home",),
                Tab(icon: Icon(Icons.library_add), text: "Catalogo",),
                Tab(icon: Icon(Icons.person), text: "Profilo",),
              ],
            ),
          ),

          /*drawer: const Drawer(
            child: ContenutoDelDrawer(),
          ),

          body: const TabBarView(
              children: [
                MyHomePage(title: "Home"),
                /*Icon(Icons.home),*/
                SchermataLista(),
                Icon(Icons.favorite),
                Icon(Icons.person),
              ]
          ),*/
          /*floatingActionButton: ,*/
        ),
    );
  }
}