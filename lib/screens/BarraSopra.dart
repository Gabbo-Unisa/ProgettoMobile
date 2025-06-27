import 'package:flutter/material.dart';
import 'GridView.dart';

class ContenutoDelDrawer extends StatelessWidget {
  const ContenutoDelDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        SizedBox(
          height: 120,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              //Mettere un po' d'ombreggiatura
            ),

            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Menu Opzioni",
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text(
            "Serie Preferite",
            style: TextStyle(fontSize: 18), // Dimensione del font leggermente aggiustata
          ),
          onTap: () {
          },
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          child: TextButton(
            onPressed: () {
              /* Chiudere il drawer prima di navigare (buona pratica)
              Navigator.pop(context);*/
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => const MyPage(title: "Non lo so"))
              );
            },
            child: const Text("Vai alla Lista"),
          ),
        ),
      ],
    );
  }
}