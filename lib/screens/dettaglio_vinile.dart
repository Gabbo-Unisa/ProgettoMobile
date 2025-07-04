import 'package:flutter/material.dart';
import 'dart:io';

import '../models/vinile.dart';
import '../models/categoria.dart';

import 'form_vinile.dart';
import 'package:provider/provider.dart';
import '../providers/vinile_provider.dart';
import '../providers/categoria_provider.dart';

class DettaglioVinile extends StatelessWidget {
  final Vinile vinile;
  const DettaglioVinile({super.key, required this.vinile});

  @override
  Widget build(BuildContext context) {

    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    final categoria = categoriaProvider.categorie.firstWhere(
          (c) => c.id == vinile.categoriaId,
      orElse: () => Categoria(id: null, nome: 'Sconosciuta'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(vinile.titolo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SchermataAggiuntaVinile(vinile: vinile, isEditing: true),
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
              Text('Artista:', style: Theme.of(context).textTheme.labelMedium),
              Text(vinile.artista, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),

              Text('Anno:', style: Theme.of(context).textTheme.labelMedium),
              Text('${vinile.anno}', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),

              Text('Categoria:', style:  Theme.of(context).textTheme.labelMedium),
              Text(categoria.nome, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),

              Text('Etichetta:', style: Theme.of(context).textTheme.labelMedium),
              Text(vinile.etichetta, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),

              Text('Condizione:', style: Theme.of(context).textTheme.labelMedium),
              Text(vinile.condizione, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
