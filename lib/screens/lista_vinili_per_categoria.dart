import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categoria_provider.dart';
import '../providers/vinile_provider.dart';

import '../models/vinile.dart';
import 'dettaglio_vinile.dart';


class ListaViniliPerCategoria extends StatelessWidget {
  final String categoria;
  final List<Vinile> vinili;

  const ListaViniliPerCategoria({
    super.key,
    required this.categoria,
    required this.vinili,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {

              final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);

              // Trova la categoria completa in base al nome
              final cat = categoriaProvider.categorie.firstWhere(
                    (c) => c.nome.trim().toLowerCase() == categoria.trim().toLowerCase(),
                orElse: () => throw Exception('Categoria non trovata'),
              );

              final conferma = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Conferma eliminazione', style: TextStyle(fontSize: 20)),
                  content: const Text('Vuoi eliminare questa categoria?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla', style: TextStyle(color: Colors.lightBlue))),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Elimina', style: TextStyle(color: Colors.lightBlue))),
                  ],
                ),
              );
              if (conferma == true) {
                final vinileProvider = Provider.of<VinileProvider>(context, listen: false);
                final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);

                await categoriaProvider.eliminaCategoria(cat.id!);
                await categoriaProvider.caricaCategorie(); // ricarica le categorie
                await vinileProvider.caricaVinili();       // ricarica i vinili

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: vinili.length,
        itemBuilder: (context, index) {
          final v = vinili[index];
          return ListTile(
            title: Text(v.titolo, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(v.artista, style: Theme.of(context).textTheme.labelSmall),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DettaglioVinile(vinile: v)));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.white24,
          indent: 16,
          endIndent: 16,
          height: 1,
        ),
      ),
    );
  }
}