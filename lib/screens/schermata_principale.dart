import '../db/database_helper.dart';
import '../models/vinile.dart';
import 'package:flutter/material.dart';
//import 'BarraSotto.dart';
import '../main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La mia homePage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const VistaTabs(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _testDatabase() async {
    final helper = DatabaseHelper.instance;

    final vinileTest1 = Vinile(
      id: 'v001',
      titolo: 'The Dark Side of the Moon',
      artista: 'Pink Floyd',
      anno: 1973,
      etichetta: 'Harvest',
      genere: 'Progressive Rock',
      condizione: 'Usato',
      copertina: null,
      preferito: true,
    );

    final vinileTest2 = Vinile(
      id: 'v002',
      titolo: 'Cheri Cheri Lady',
      artista: 'Modern Talking',
      anno: 1980,
      etichetta: 'Harvest',
      genere: 'Progressive Rock',
      condizione: 'Nuovo',
      copertina: null,
      preferito: false,
    );

    await helper.insertVinile(vinileTest1);
    debugPrint('✅ Vinile inserito!');

    await helper.insertVinile(vinileTest2);
    debugPrint('✅ Vinile inserito!');

    final vinili = await helper.getVinili();
    debugPrint('📀 Vinili nel database:');
    for (var v in vinili) {
      debugPrint('${v.titolo} - ${v.artista} (${v.anno})');
    }
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void fiveIncrementCounter(){
    setState(() {
      _counter = _counter + 5;
    });
  }

  void tenIncrementCounter(){
    setState(() {
      _counter = _counter + 10;
    });
  }


  void toAccount(){
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: const MyHomePage(title: 'La mia homePage'),
      );
    }
  }

  void adderList(){
    int i=0;
    _counter = _counter + i;
  }

  List<int> list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            /*mainAxisAlignment: MainAxisAlignment.center,*/
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 100,
                color: Colors.lightGreenAccent,
        
                child: Text("Serie non Preferite:",
                  style: TextStyle(fontSize: 30)
                ),
              ),
              TextButton(
                onPressed: _testDatabase,
                child: Text("Test DB: Inserisci & Leggi vinili"),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                color: Colors.lightGreenAccent,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(20),
                    children: [
                      for (var i in list)
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          child: SizedBox.expand(
                            child: TextButton(
                              onPressed: (){
                                setState(() {
                                  _counter = _counter + i;
                                });
                              },
                              child: Text('$i')
                            ),
                          ),
                        ),
        
                    ],
                  ),
                ),
              ),
        
              const Text(
                  'Numero di volte che il contatore ha incrementato:'
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                  onPressed: resetCounter,
                  child: Text("Resetta il contatore.")
              ),
              TextButton(
                  onPressed: fiveIncrementCounter,
                  child: Text("Incrementa il contatore di 5.")
              ),
              TextButton(
                  onPressed: tenIncrementCounter,
                  child: Text("Incrementa il contatore di 10.")
              )
            ],
          ),
        ),
      ),

      /*bottomNavigationBar: Barrasotto(
        /*selectedIndex: _currentPageIndex,
        onDestinationSelected: _onNavigationBarItemTapped,*/
      ),*/


      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Incrementa il contatore',
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Modifica questo valore per cambiare l'arrotondamento
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
    );
  }
}
