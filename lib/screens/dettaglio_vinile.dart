import 'package:flutter/material.dart';
import 'dart:io';

import '../models/vinile.dart';
import 'form_vinile.dart';
import 'package:provider/provider.dart';
import '../providers/vinile_provider.dart';

class DettaglioVinile extends StatelessWidget {
  final Vinile vinile;
  const DettaglioVinile({super.key, required this.vinile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vinile.titolo, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF000B23),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SchermataForm(vinile: vinile, isEditing: true),
                ),
              );
              // Ricarica i vinili al ritorno
              await Provider.of<VinileProvider>(context, listen: false).caricaVinili();
              Navigator.pop(context); // Chiude il dettaglio dopo modifica
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final conferma = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Conferma eliminazione', style: TextStyle(fontSize: 20)),
                  content: const Text('Vuoi eliminare questo vinile?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla', style: TextStyle(color: Colors.lightBlue))),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Elimina', style: TextStyle(color: Colors.lightBlue))),
                  ],
                ),
              );
              if (conferma == true) {
                await Provider.of<VinileProvider>(context, listen: false).eliminaVinile(vinile.id!);
                Navigator.pop(context); // Torna indietro dopo l'eliminazione
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF000B23),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Center( // Centra solo la copertina
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: vinile.copertina != null && vinile.copertina!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(vinile.copertina!),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported, size: 48, color: Colors.white38),
                          SizedBox(height: 10),
                          Text(
                            'Nessuna copertina',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width / 2 - 104, // allineata appena fuori la copertina
                    top: -1.5,
                    child: Transform.rotate(
                      angle: -45,
                      child: Icon(
                        vinile.preferito ? Icons.star : Icons.star,
                        color: vinile.preferito ? Colors.amber : Colors.white70,
                        size: 28,
                        grade: -30.0,
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Artista:', style: TextStyle(color: Colors.white60, fontSize: 16)),
              Text(vinile.artista, style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),

              const Text('Anno:', style: TextStyle(color: Colors.white60, fontSize: 16)),
              Text('${vinile.anno}', style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),

              const Text('Genere:', style: TextStyle(color: Colors.white60, fontSize: 16)),
              Text(vinile.genere, style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),

              const Text('Etichetta:', style: TextStyle(color: Colors.white60, fontSize: 16)),
              Text(vinile.etichetta, style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),

              const Text('Condizione:', style: TextStyle(color: Colors.white60, fontSize: 16)),
              Text(vinile.condizione, style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
