import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/categoria.dart';
import '../providers/categoria_provider.dart';

class SchermataAggiuntaCategoria extends StatefulWidget {
  const SchermataAggiuntaCategoria({super.key});

  @override
  State<SchermataAggiuntaCategoria> createState() => _SchermataAggiuntaCategoriaState();
}

class _SchermataAggiuntaCategoriaState extends State<SchermataAggiuntaCategoria> {
  final _formKey = GlobalKey<FormState>();
  String? _nomeCategoria;

  void _salvaCategoria() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);

      // Controllo se la categoria esiste già
      final nomeNorm = _nomeCategoria!.trim().toLowerCase();

      final duplicata = categoriaProvider.categorie.any(
            (c) => c.nome.trim().toLowerCase() == nomeNorm,
      );

      if (duplicata) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria già esistente')),
        );
        return;
      }

      final nuovaCategoria = Categoria(nome: _nomeCategoria!.trim());
      await categoriaProvider.aggiungiCategoria(nuovaCategoria);

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome categoria'
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Inserisci un nome' : null,
                onSaved: (value) => _nomeCategoria = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvaCategoria,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                child: const Text('Salva', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}