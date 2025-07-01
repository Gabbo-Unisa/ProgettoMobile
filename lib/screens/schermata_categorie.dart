import 'package:flutter/material.dart';

class SchermataCategorie extends StatefulWidget {
  const SchermataCategorie({super.key});

  @override
  State<SchermataCategorie> createState() => _SchermataCategorieState();
}

class _SchermataCategorieState extends State<SchermataCategorie> {

  final int _numeroTabs = 3;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _numeroTabs,
      child: Scaffold(
        backgroundColor: const Color(0xFF000B23),
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                  indicatorColor: Colors.lightBlue,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: const <Tab>[
                    Tab(text: 'Tutti'),
                    Tab(text: 'Preferiti'),
                    Tab(text: 'Statistiche'),
                  ]
              ),
            ],
          ),
          backgroundColor: const Color(0xFF000B23),
        ),

        body: TabBarView(
          children: <Widget>[
            const Center(child: Text('Tutti', style: TextStyle(color: Colors.white))),
            const Center(child: Text('Preferiti', style: TextStyle(color: Colors.white))),
            const Center(child: Text('Statistiche', style: TextStyle(color: Colors.white))),
          ]
        ),
      ),
    );
  }
}