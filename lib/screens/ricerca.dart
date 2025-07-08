import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ricerca_provider.dart';
import '../screens/vinili_list_view.dart';

class SchermataRicerca extends StatefulWidget {
  const SchermataRicerca({super.key});

  @override
  State<SchermataRicerca> createState() => _SchermataRicercaState();
}

class _SchermataRicercaState extends State<SchermataRicerca> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ricercaProvider = Provider.of<RicercaProvider>(context);
    final risultati = ricercaProvider.risultati;
    final suggerimenti = ricercaProvider.suggerimenti;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra di ricerca
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Cerca per titolo o artista...',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => ricercaProvider.aggiornaRicerca(val),
                    ),
                  ),
                ],
              ),
            ),

            // Suggerimenti ricerca
            if (ricercaProvider.suggerimenti.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Column(
                  children:
                      ricercaProvider.suggerimenti.map((suggerimento) {
                        return ListTile(
                          title: Text(suggerimento),
                          onTap: () {
                            _controller.text = suggerimento;
                            ricercaProvider.applicaSuggerimento(suggerimento);
                          },
                        );
                      }).toList(),
                ),
              ),

            const Divider(height: 1, thickness: 1),

            // Lista vinili
            Expanded(
              child: ViniliListView(
                vinili: risultati,
                messaggio: 'Nessun vinile trovato.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
