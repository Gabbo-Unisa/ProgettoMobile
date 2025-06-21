import 'package:first_example/SchermataLista.dart';
import 'package:flutter/material.dart';
import 'BarraSotto.dart';
import 'BarraSopra.dart';
import 'SchermataPrincipale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le mie tabs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const VistaTabs(title: 'Le mie tabs'),
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
    return MaterialApp(
      title: 'Le mie tabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            /*scrolledUnderElevation: 4,*/
            title: Text(widget.title),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,

            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home), text: "Home",),
                Tab(icon: Icon(Icons.format_align_left), text: "Lista Serie",),
                Tab(icon: Icon(Icons.favorite), text: "Serie Preferite",),
                Tab(icon: Icon(Icons.person), text: "Profilo",),
              ],
            ),
          ),

          drawer: const Drawer(
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
          ),
          /*floatingActionButton: ,*/
        )
      )
    );
  }
}