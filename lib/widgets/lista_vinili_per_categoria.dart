import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categoria_provider.dart';
import '../providers/vinile_provider.dart';

import '../models/vinile.dart';
import '../screens/dettaglio_vinile.dart';

class ListaViniliPerCategoria extends StatefulWidget {
  final String categoria;
  final List<Vinile> vinili;

  const ListaViniliPerCategoria({
    super.key,
    required this.categoria,
    required this.vinili,
  });

  @override
  State<ListaViniliPerCategoria> createState() =>
      _ListaViniliPerCategoriaState();
}

class _ListaViniliPerCategoriaState extends State<ListaViniliPerCategoria> {
  late List<Vinile> vinili;

  @override
  void initState() {
    super.initState();
    vinili = widget.vinili;
  }

  Future<void> _aggiornaVinili() async {
    final vinileProvider = Provider.of<VinileProvider>(context, listen: false);
    await vinileProvider.caricaVinili();

    setState(() {
      vinili =
          vinileProvider.vinili
              .where((v) => v.categoriaId == widget.vinili.first.categoriaId)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoria),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final categoriaProvider = Provider.of<CategoriaProvider>(
                  context,
                  listen: false,
                );

                final cat = categoriaProvider.categorie.firstWhere(
                  (c) =>
                      c.nome.trim().toLowerCase() ==
                      widget.categoria.trim().toLowerCase(),
                  orElse: () => throw Exception('Categoria non trovata'),
                );

                final conferma = await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Conferma eliminazione'),
                        content: const Text('Vuoi eliminare questa categoria?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annulla'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Elimina'),
                          ),
                        ],
                      ),
                );

                if (conferma == true) {
                  await categoriaProvider.eliminaCategoria(cat.id!);
                  await categoriaProvider.caricaCategorie();
                  await Provider.of<VinileProvider>(
                    context,
                    listen: false,
                  ).caricaVinili();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: vinili.length,
          itemBuilder: (context, index) {
            final vinile = vinili[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                  8,
                ), // stesso raggio per entrambi
                child:
                    vinile.copertina != null
                        ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.file(
                            File(vinile.copertina!),
                            fit: BoxFit.cover,
                          ),
                        )
                        : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.album,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
              ),
              title: Text(vinile.titolo),
              subtitle: Text(vinile.artista),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DettaglioVinile(vinile: vinile),
                  ),
                ).then((_) => _aggiornaVinili());
              },
            );
          },
        ),
      ),
    );
  }
}
