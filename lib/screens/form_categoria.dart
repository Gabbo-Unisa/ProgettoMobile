import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/categoria.dart';
import '../providers/categoria_provider.dart';

class SchermataAggiuntaCategoria extends StatefulWidget {
  const SchermataAggiuntaCategoria({super.key});

  @override
  State<SchermataAggiuntaCategoria> createState() =>
      _SchermataAggiuntaCategoriaState();
}

class _SchermataAggiuntaCategoriaState
    extends State<SchermataAggiuntaCategoria> {
  final _formKey = GlobalKey<FormState>();
  String? _nomeCategoria;

  void _salvaCategoria() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final categoriaProvider = Provider.of<CategoriaProvider>(
        context,
        listen: false,
      );

      // Normalizza il nome: rimuove spazi extra, mette in minuscolo
      final nomeNorm =
          _nomeCategoria!.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

      // Il nome finale avrà la prima lettera maiuscola di ogni parola
      final nomeFinale = nomeNorm
          .split(' ')
          .map(
            (parola) =>
                parola.isNotEmpty
                    ? '${parola[0].toUpperCase()}${parola.substring(1)}'
                    : '',
          )
          .join(' ');

      // Controlla se esiste già una categoria con lo stesso nome (ignorando maiuscole/minuscole)
      final duplicata = categoriaProvider.categorie.any(
        (c) => c.nome.trim().toLowerCase() == nomeNorm,
      );

      if (duplicata) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria già esistente')),
        );
        return;
      }

      final nuovaCategoria = Categoria(nome: nomeFinale);
      await categoriaProvider.aggiungiCategoria(nuovaCategoria);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova Categoria')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome categoria'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Inserisci un nome'
                            : null,
                onSaved: (value) => _nomeCategoria = value,
              ),
              const SizedBox(height: 40),
              FloatingActionButton.extended(
                onPressed: _salvaCategoria,
                icon: const Icon(Icons.save),
                label: const Text('Salva categoria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
