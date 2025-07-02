import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/vinile.dart';
import '../providers/vinile_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../db/database_helper.dart';

class SchermataForm extends StatefulWidget {
  final Vinile? vinile;
  final bool isEditing;

  const SchermataForm({super.key, this.vinile, this.isEditing = false});


  @override
  State<SchermataForm> createState() => _SchermataFormState();
}

class _SchermataFormState extends State<SchermataForm> {
  final _formKey = GlobalKey<FormState>();

  String? titolo, artista, etichetta, condizione, genere;
  int? anno;
  File? copertina;
  bool preferito = false;

  final List<String> condizioni = ['Nuovo', 'Usato', 'Da restaurare'];
  final List<String> generi = ['Rock', 'Pop', 'Jazz', 'Classica', 'Altro'];

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.vinile != null) {
      final v = widget.vinile!;
      titolo = v.titolo;
      artista = v.artista;
      anno = v.anno;
      etichetta = v.etichetta;
      genere = v.genere;
      condizione = v.condizione;
      preferito = v.preferito;
      if (v.copertina != null) {
        copertina = File(v.copertina!);
      }
    }
  }


  final picker = ImagePicker();

  Future<void> _scegliImmagine() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        copertina = File(picked.path);
      });
    }
  }

  void _salvaVinile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final nuovoVinile = Vinile(
        id: widget.vinile?.id,
        titolo: titolo!,
        artista: artista!,
        anno: anno!,
        etichetta: etichetta!,
        genere: genere!,
        condizione: condizione!,
        preferito: preferito,
        copertina: copertina?.path,
      );

      final vinileProvider = Provider.of<VinileProvider>(context, listen: false);

      if (widget.isEditing) {
        await vinileProvider.aggiornaVinile(nuovoVinile);
      } else {
        await vinileProvider.aggiungiVinile(nuovoVinile);
      }

      //Test inserimento Vinili nel database
      final helper = DatabaseHelper.instance;
      final vinili = await helper.getVinili();
      debugPrint('📀 Vinili nel database:');
      for (var v in vinili) {
        debugPrint(v.toString());
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Modifica Vinile' : 'Aggiungi Vinile',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000B23),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF000B23),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Titolo
              TextFormField(
                initialValue: titolo,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Titolo',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Inserisci un titolo' : null,
                onSaved: (val) => titolo = val,
              ),

              // Artista
              TextFormField(
                initialValue: artista,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Artista',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Inserisci un artista' : null,
                onSaved: (val) => artista = val,
              ),

              // Anno
              TextFormField(
                initialValue: anno?.toString(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Anno',
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Inserisci un anno';
                  final parsed = int.tryParse(val);
                  if (parsed == null || parsed < 1800 || parsed > DateTime.now().year) {
                    return 'Anno non valido';
                  }
                  return null;
                },
                onSaved: (val) => anno = int.tryParse(val ?? ''),
              ),

              // Etichetta
              TextFormField(
                initialValue: etichetta,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Etichetta',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Inserisci una etichetta' : null,
                onSaved: (val) => etichetta = val,
              ),

              // Genere
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  value: genere,
                  items: generi.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) => setState(() => genere = val),
                  onSaved: (val) => genere = val,
                  validator: (val) => val == null ? 'Seleziona un genere' : null,
                  decoration: const InputDecoration(
                    labelText: 'Genere',
                  ),
                  dropdownColor: const Color(0xFF001237),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              // Condizione
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  value: condizione,
                  items: condizioni.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => condizione = val),
                  onSaved: (val) => condizione = val,
                  validator: (val) => val == null ? 'Seleziona una condizione' : null,
                  decoration: const InputDecoration(
                    labelText: 'Condizione',
                  ),
                  dropdownColor: const Color(0xFF001237),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Preferito
              SwitchListTile(
                title: const Text('Preferito', style: TextStyle(color: Colors.white)),
                value: preferito,
                onChanged: (val) => setState(() => preferito = val),
              ),

              const SizedBox(height: 16),

              // Immagine copertina
              ElevatedButton(
                onPressed: _scegliImmagine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001237),
                ),
                child: const Text('Seleziona immagine copertina', style: TextStyle(color: Colors.white)),
              ),
              if (copertina != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Image.file(copertina!, height: 150),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _salvaVinile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001237),
                ),
                child: const Text('Salva vinile', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
