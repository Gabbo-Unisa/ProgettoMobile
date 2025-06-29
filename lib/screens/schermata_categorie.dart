import 'package:flutter/material.dart';
import 'BarraSopra.dart';
import 'schermata_categorie.dart';

void main() {
  runApp(const SchermataLista());
}

class SchermataLista extends StatelessWidget {
  const SchermataLista({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchermataLista',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      home: const MyPage(title: 'SchermataLista'),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.title});

  final String title;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<int> list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ListView(
        /*padding: EdgeInsets.all(8),*/

        children: [
          for(var i in list)
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.lightBlue,

              ),
              /*color: Colors.lightBlue,*/
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$i'),
                    Checkbox(
                        value: false,
                        onChanged: null
                        /*Al posto del null ci andrà il metodo che
                        * inserirà quella serie tra i preferiti*/
                    )
                  ],
                ),
              ),

            ),

        ],

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: null,
        /*Metodo per aggiungere una serie alla lista delle serie*/
        tooltip: '',
        child: const Icon(Icons.add),
      ),

    );
  }

}
