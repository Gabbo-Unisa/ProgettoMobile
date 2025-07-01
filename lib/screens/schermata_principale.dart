import 'package:flutter/material.dart';
import 'form_vinile.dart';
//import '../models/vinile.dart';

class SchermataPrincipale extends StatefulWidget {
  const SchermataPrincipale({super.key});

  @override
  State<SchermataPrincipale> createState() => _SchermataPrincipaleState();
}

class _SchermataPrincipaleState extends State<SchermataPrincipale> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000B23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Benvenuto nella nostra app', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF001237),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchermataForm(
                /*vinile: Vinile(
                  id: 1, // ID fittizio (meglio se realmente esiste nel DB)
                  titolo: 'Dark Side of the Moon',
                  artista: 'Pink Floyd',
                  anno: 1973,
                  etichetta: 'Harvest',
                  genere: 'Rock',
                  condizione: 'Usato',
                  preferito: true,
                  copertina: null,
                ),
                 isEditing: true,*/
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}