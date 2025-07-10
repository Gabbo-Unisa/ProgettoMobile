import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vinile_provider.dart';
import '../providers/categoria_provider.dart';

import '../models/categoria.dart';
import 'dettaglio_vinile.dart';
import 'form_categoria.dart';
import '../widgets/lista_vinili_per_categoria.dart';
import '../widgets/vinili_list_view.dart';

class SchermataLibreria extends StatefulWidget {
  const SchermataLibreria({super.key});

  @override
  State<SchermataLibreria> createState() => _SchermataLibreriaState();
}

class _SchermataLibreriaState extends State<SchermataLibreria> {
  final int _numeroTabs = 3;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      Provider.of<VinileProvider>(context, listen: false).caricaVinili();
      Provider.of<CategoriaProvider>(
        context,
        listen: false,
      ).caricaCategorie().then((_) {
        setState(() => _loaded = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VinileProvider>(context);
    final vinili = provider.vinili;
    final viniliPreferiti = vinili.where((v) => v.preferito).toList();

    return DefaultTabController(
      length: _numeroTabs, // 3
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const TabBar(
            tabs: <Tab>[
              Tab(text: 'Tutti'),
              Tab(text: 'Categorie'),
              Tab(text: 'Preferiti'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              ViniliListView(
                vinili: vinili,
                messaggio: "Nessun vinile nella libreria",
              ),
              _buildTabCategorie(provider),
              ViniliListView(
                vinili: viniliPreferiti,
                messaggio: "Nessun vinile preferito",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabCategorie(VinileProvider provider) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    final categorie = categoriaProvider.categorie;

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      itemCount: categorie.length + 2, // 1 per "Senza categoria", 1 per "Aggiungi categoria"
      itemBuilder: (context, index) {
        final countNull =
            provider.vinili.where((v) => v.categoriaId == null).length;

        // Primo elemento: "Senza categoria"
        if (index == 0) {
          return ListTile(
            title: const Text('Senza categoria'),
            trailing: Text('${countNull}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ListaViniliPerCategoria(
                        categoria: 'Senza categoria',
                        vinili:
                            provider.vinili
                                .where((v) => v.categoriaId == null)
                                .toList(),
                      ),
                ),
              );
            },
          );
        }

        // Ultimo elemento: "Aggiungi categoria"
        if (index == categorie.length + 1) {
          return ListTile(
            title: const Text(
              'Aggiungi categoria',
              style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            leading: const Icon(Icons.add, color: Colors.deepPurple),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchermataAggiuntaCategoria(),
                ),
              ).then((_) async {
                await Provider.of<CategoriaProvider>(
                  context,
                  listen: false,
                ).caricaCategorie();
                setState(() {});
              });
            },
          );
        }

        // Categoria normale
        final cat = categorie[index - 1]; // -1 perché il primo è "Senza categoria"
        final count = provider.vinili.where((v) => v.categoriaId == cat.id).length;

        return ListTile(
          title: Text(cat.nome),
          trailing: Text('$count'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListaViniliPerCategoria(
                      categoria: cat.nome,
                      vinili:
                          provider.vinili
                              .where((v) => v.categoriaId == cat.id)
                              .toList(),
                    ),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        if (index == categorie.length + 1)
          return const SizedBox.shrink(); // No divider after last
        return const Divider(
          color: Colors.white24,
          height: 1,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        );
      },
    );
  }

  Widget _buildTabPreferiti(VinileProvider provider) {
    final fav = provider.vinili.where((v) => v.preferito).toList();

    if (!_loaded) return const Center(child: CircularProgressIndicator());

    if (fav.isEmpty) {
      return Center(
        child: Text(
          'Nessun preferito',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      itemCount: fav.length,
      itemBuilder: (context, index) {
        final v = fav[index];

        final categoriaProvider = Provider.of<CategoriaProvider>(
          context,
          listen: false,
        );
        final categoria = categoriaProvider.categorie.firstWhere(
          (c) => c.id == v.categoriaId,
          orElse: () => Categoria(id: null, nome: 'Sconosciuta'),
        );

        return ListTile(
          title: Text(v.titolo, style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text(
            v.artista + ' • ' + categoria.nome,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DettaglioVinile(vinile: v),
              ),
            );
          },
        );
      },
      separatorBuilder:
          (context, index) => const Divider(
            color: Colors.white24,
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
    );
  }
}
