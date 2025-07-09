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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap:
          () =>
              FocusScope.of(context).unfocus(), // chiude la tastiera sul click
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // barra di ricerca
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
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          hintText: 'Cerca per titolo...',
                          border: OutlineInputBorder(),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onChanged:
                            (val) => ricercaProvider.aggiornaRicerca(val),
                        onSubmitted:
                            (val) => ricercaProvider.aggiornaRicerca(val),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // suggerimenti
              if (suggerimenti.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      isLandscape // Responsive
                          // Schermo in orizzontale
                          ? Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                suggerimenti.map((s) {
                                  return ActionChip(
                                    label: Text(s),
                                    onPressed: () {
                                      _controller.text = s;
                                      ricercaProvider.applicaSuggerimento(s);
                                      FocusScope.of(context).unfocus();
                                    },
                                    backgroundColor: Colors.blueGrey.shade800,
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                          )
                          // Schermo in verticale
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                suggerimenti.map((s) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: ActionChip(
                                      label: Text(s),
                                      onPressed: () {
                                        _controller.text = s;
                                        ricercaProvider.applicaSuggerimento(s);
                                        FocusScope.of(context).unfocus();
                                      },
                                      backgroundColor: Colors.blueGrey.shade800,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                ),

              const Divider(height: 20, thickness: 1),

              // risultati ricerca
              Expanded(
                child: ViniliListView(
                  vinili: risultati,
                  messaggio: 'Nessun vinile trovato.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
