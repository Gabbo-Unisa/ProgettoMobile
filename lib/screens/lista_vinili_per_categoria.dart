import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categoria_provider.dart';
import '../providers/vinile_provider.dart';

import '../models/vinile.dart';
import 'dettaglio_vinile.dart';


class ListaViniliPerCategoria extends StatefulWidget {
  final String categoria;
  final List<Vinile> vinili;

  const ListaViniliPerCategoria({
    super.key,
    required this.categoria,
    required this.vinili,
  });

  @override
  State<ListaViniliPerCategoria> createState() => _ListaViniliPerCategoriaState();
}

class _ListaViniliPerCategoriaState extends State<ListaViniliPerCategoria> {
  late List<Vinile> viniliPerCategoria;

  @override
  void initState() {
    super.initState();
    viniliPerCategoria = widget.vinili;
  }

  Future<void> _aggiornaVinili() async {
    final vinileProvider = Provider.of<VinileProvider>(context, listen: false);
    await vinileProvider.caricaVinili();

    setState(() {
      viniliPerCategoria = vinileProvider.vinili
          .where((v) => v.categoriaId == widget.vinili.first.categoriaId)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);

              final cat = categoriaProvider.categorie.firstWhere(
                    (c) => c.nome.trim().toLowerCase() == widget.categoria.trim().toLowerCase(),
                orElse: () => throw Exception('Categoria non trovata'),
              );

              final conferma = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Conferma eliminazione'),
                  content: const Text('Vuoi eliminare questa categoria?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Elimina')),
                  ],
                ),
              );

              if (conferma == true) {
                await categoriaProvider.eliminaCategoria(cat.id!);
                await categoriaProvider.caricaCategorie();
                await Provider.of<VinileProvider>(context, listen: false).caricaVinili();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: viniliPerCategoria.length,
        itemBuilder: (context, index) {
          final v = viniliPerCategoria[index];
          return ListTile(
            title: Text(v.titolo, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(v.artista, style: Theme.of(context).textTheme.labelSmall),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DettaglioVinile(vinile: v))
                            ).then((_) => _aggiornaVinili());
            },
          );
        },
        separatorBuilder: (_, __) => const Divider(
          color: Colors.white24,
          indent: 16,
          endIndent: 16,
          height: 1,
        ),
      ),
    );
  }
}