import 'package:flutter/material.dart';
import 'BarraSopra.dart';
import 'SchermataLista.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      home: const MyPage(title: 'GridView'),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),


      drawer: Drawer(
        child: ContenutoDelDrawer(),
      ),


      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        onRefresh: () async {
            return Future<void>.delayed(const Duration(seconds: 2));
        },


        child: Padding(
          padding: EdgeInsets.all(8),
            child: GridView.count(
                 physics: const AlwaysScrollableScrollPhysics(), // Riga necessaria per far funzionare il refresh
                 mainAxisSpacing: 8,
                 crossAxisSpacing: 8,
                 crossAxisCount: 4,
                 children: [
                   for (var i in list)
                     Container(
                       padding: EdgeInsets.all(8),
                       alignment: Alignment.center,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8),
                         color: Colors.blue,
                       ),
                       child: Text('$i'),
                    ),
                ],
            ),
          ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: '',
        child: const Icon(Icons.add),
      ),

    );
  }

}
