import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vinile_provider.dart';
import 'dettaglio_vinile.dart';

class SchermataCategorie extends StatefulWidget {
  const SchermataCategorie({super.key});

  @override
  State<SchermataCategorie> createState() => _SchermataCategorieState();
}

class _SchermataCategorieState extends State<SchermataCategorie> {

  final int _numeroTabs = 3;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      // Carica i vinili una sola volta
      Provider.of<VinileProvider>(context, listen: false)
          .caricaVinili()
          .then((_) {
        setState(() => _loaded = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<VinileProvider>(context);

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
                  unselectedLabelColor: Colors.white60,
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

            // Tab "Tutti"
            if (!_loaded)
              const Center(child: CircularProgressIndicator())
            else if (provider.vinili.isEmpty)
              const Center(
                child: Text('Nessun vinile presente.',
                    style: TextStyle(color: Colors.white70)),
              )
            else
              ListView.separated(
                itemCount: provider.vinili.length,
                itemBuilder: (context, index) {
                  final vinile = provider.vinili[index];
                  return ListTile(
                    title: Text(vinile.titolo,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${vinile.artista} • ${vinile.anno}',
                        style: const TextStyle(color: Colors.white70)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DettaglioVinile(vinile: vinile)
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white24,
                  height: 1,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16,
                ),
              ),

            // Tab "Preferiti"
            Consumer<VinileProvider>(
              builder: (context, provider, _) {
                final fav = provider.vinili.where((v) => v.preferito).toList();

                if (!_loaded) return const Center(child: CircularProgressIndicator());

                if (fav.isEmpty) {
                  return const Center(
                    child: Text('Nessun preferito.',
                        style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.separated(
                  itemCount: fav.length,
                  itemBuilder: (context, index) {
                    final v = fav[index];
                    return ListTile(
                      title: Text(v.titolo, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(v.artista, style: const TextStyle(color: Colors.white70)),
                      //trailing: const Icon(Icons.star, color: Colors.amber),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DettaglioVinile(vinile: v)
                          )
                        );
                      }
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.white24,
                    height: 1,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  ),
                );
              },
            ),

            const Center(child: Text('Statistiche', style: TextStyle(color: Colors.white))),
          ]
        ),
      ),
    );
  }
}