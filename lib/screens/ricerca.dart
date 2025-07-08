import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ricerca_provider.dart';
import '../widgets/vinili_list_view.dart';

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
                        hintText: 'Cerca per titolo...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: (val) => ricercaProvider.aggiornaRicerca(val),
                    ),
                  ),
                ],
              ),
            ),

            // Suggerimenti ricerca
            if (ricercaProvider.suggerimenti.isNotEmpty)
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ), // altezza max
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ricercaProvider.suggerimenti.length,
                    itemBuilder: (context, index) {
                      final suggerimento = ricercaProvider.suggerimenti[index];
                      return ListTile(
                        title: Text(suggerimento),
                        onTap: () {
                          _controller.text = suggerimento;
                          ricercaProvider.applicaSuggerimento(suggerimento);
                        },
                      );
                    },
                  ),
                ),
              ),

            const Divider(height: 1, thickness: 1),

            // Lista vinili scrollabile e adattabile
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
