import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'form_categoria.dart';

import '../providers/vinile_provider.dart';
import '../providers/categoria_provider.dart';
import '../db/database_helper.dart';

import '../models/categoria.dart';
import '../models/vinile.dart';

class SchermataAggiuntaVinile extends StatefulWidget {
  final Vinile? vinile;
  final bool isEditing;

  const SchermataAggiuntaVinile({
    super.key,
    this.vinile,
    this.isEditing = false,
  });

  @override
  State<SchermataAggiuntaVinile> createState() => _SchermataFormState();
}

class _SchermataFormState extends State<SchermataAggiuntaVinile> {
  final _formKey = GlobalKey<FormState>();

  String? titolo, artista, etichetta, condizione, note;
  int? anno;
  File? copertina;
  bool preferito = false;
  int? categoriaId;

  final List<String> condizioni = ['Nuovo', 'Usato', 'Da restaurare'];

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.vinile != null) {
      final v = widget.vinile!;
      titolo = v.titolo;
      artista = v.artista;
      anno = v.anno;
      etichetta = v.etichetta;
      condizione = v.condizione;
      preferito = v.preferito;
      note = v.note;
      if (v.copertina != null) {
        copertina = File(v.copertina!);
      }
      categoriaId = v.categoriaId;
    }
  }

  final picker = ImagePicker();

  Future<void> _scegliImmagine() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      // 1. Ottieni directory persistente
      final appDir = await getApplicationDocumentsDirectory();

      // 2. Crea un nome unico per evitare conflitti
      final nomeFile =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(picked.path)}';

      // 3. Costruisci nuovo path persistente
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$nomeFile');

      // 4. Salva il file persistente nello stato
      setState(() {
        copertina = savedImage;
      });
    }
  }

  void _rimuoviCopertina() async {
    if (copertina != null && await copertina!.exists()) {
      await copertina!.delete(); // elimina il file dal filesystem
    }

    setState(() {
      copertina = null;
    });
  }

  void _salvaVinile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final vinileProvider = Provider.of<VinileProvider>(
        context,
        listen: false,
      );

      // Controllo se il vinile esiste già
      final titoloNorm = titolo!.trim().toLowerCase();
      final artistaNorm = artista!.trim().toLowerCase();

      final duplicato = vinileProvider.vinili.any(
        (v) =>
            v.titolo.trim().toLowerCase() == titoloNorm &&
            v.artista.trim().toLowerCase() == artistaNorm &&
            v.id != widget.vinile?.id,
      );

      if (duplicato) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vinile già esistente')));
        return;
      }

      final nuovoVinile = Vinile(
        id: widget.vinile?.id,
        titolo: titolo!,
        artista: artista!,
        anno: anno,
        etichetta: etichetta,
        condizione: condizione,
        preferito: preferito,
        note: note,
        copertina: copertina?.path,
        categoriaId: categoriaId,
      );

      if (widget.isEditing) {
        await vinileProvider.aggiornaVinile(nuovoVinile);
      } else {
        await vinileProvider.aggiungiVinile(nuovoVinile);
      }

      //Test inserimento Vinili nel database
      final helper = DatabaseHelper.instance;
      final vinili = await helper.getVinili();
      debugPrint('Vinili nel database:');
      for (var v in vinili) {
        debugPrint(v.toString());
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    final categorie = categoriaProvider.categorie;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifica Vinile' : 'Aggiungi Vinile'),
        actions: [
          IconButton(
            icon: Icon(
              preferito ? Icons.favorite : Icons.favorite_border,
              color: preferito ? Colors.red : Colors.white,
            ),
            onPressed: () => setState(() => preferito = !preferito),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Copertina
                GestureDetector(
                  onTap: _scegliImmagine,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white30),
                        ),
                        child:
                            copertina != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    copertina!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                      color: Colors.white38,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Nessuna copertina',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                      ),
                      if (copertina != null)
                        TextButton.icon(
                          onPressed: () {
                            _rimuoviCopertina();
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          label: const Text(
                            'Elimina copertina',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Titolo
                TextFormField(
                  initialValue: titolo,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Titolo'),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Inserisci un titolo'
                              : null,
                  onSaved: (val) => titolo = val?.trim(),
                ),

                // Artista
                TextFormField(
                  initialValue: artista,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Artista'),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Inserisci un artista'
                              : null,
                  onSaved: (val) => artista = val?.trim(),
                ),

                // Anno
                TextFormField(
                  initialValue: anno?.toString(),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Anno'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return null; // campo opzionale
                    }

                    final parsed = int.tryParse(val);
                    final currentYear = DateTime.now().year;

                    if (parsed == null ||
                        parsed < 1800 ||
                        parsed > currentYear) {
                      return 'Anno non valido (tra 1800 e $currentYear)';
                    }

                    return null;
                  },
                  onSaved: (val) => anno = int.tryParse(val ?? ''),
                ),

                // Etichetta
                TextFormField(
                  initialValue: etichetta,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Etichetta'),
                  onSaved: (val) => etichetta = val,
                ),

                // Categoria
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value:
                            categoriaId != -1 &&
                                    categorie.any((c) => c.id == categoriaId)
                                ? categoriaId
                                : null,
                        items: [
                          ...categorie.map(
                            (c) => DropdownMenuItem<int>(
                              value: c.id,
                              child: Text(c.nome),
                            ),
                          ),
                          const DropdownMenuItem<int>(
                            value: -1,
                            child: Text(
                              '+ Aggiungi nuova categoria',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        onChanged: (val) async {
                          if (val == -1) {
                            final nuovaCategoria = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const SchermataAggiuntaCategoria(),
                              ),
                            );
                            setState(() => categoriaId = null);
                          } else {
                            setState(() => categoriaId = val);
                          }
                        },
                        onSaved: (val) => categoriaId = val,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                        dropdownColor: const Color(0xFF001237),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (categoriaId != null)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => setState(() => categoriaId = null),
                        tooltip: 'Rimuovi categoria',
                      ),
                  ],
                ),

                // Condizione
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: condizione,
                        items:
                            condizioni
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => condizione = val),
                        onSaved: (val) => condizione = val,
                        decoration: const InputDecoration(
                          labelText: 'Condizione',
                        ),
                        dropdownColor: const Color(0xFF001237),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (condizione != null)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => setState(() => condizione = null),
                        tooltip: 'Rimuovi condizione',
                      ),
                  ],
                ),

                // Note
                TextFormField(
                  maxLines: 3,
                  initialValue: note,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Aggiungi note...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint:
                        true, // per centrare verticalmente la label
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSaved: (val) => note = val,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvaVinile,
        icon: const Icon(Icons.save),
        label: const Text('Salva vinile'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
