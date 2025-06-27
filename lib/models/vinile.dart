class Vinile {
  final String id;
  final String titolo;
  final String artista;
  final int anno;
  final String genere;
  final String etichetta;
  final String condizione;
  final String? copertina; // path immagine (può essere null)
  final bool preferito;

  const Vinile({
    required this.id,
    required this.titolo,
    required this.artista,
    required this.anno,
    required this.genere,
    required this.etichetta,
    required this.condizione,
    this.copertina,
    this.preferito = false,
  });

  // Converte un Vinile in una Map; le chiavi sono le colonne
  // della tabella 'vinili' nel database
  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'titolo': titolo,
      'artista': artista,
      'anno': anno,
      'genere': genere,
      'etichetta': etichetta,
      'condizione': condizione,
      'copertina': copertina,
      'preferito': preferito ? 1 : 0,
    };
  }

  // Serve per ricreare un oggetto Vinile a partire da una riga del database
  // (che viene restituita come una Map<String, dynamic> da SQLite)
  factory Vinile.fromMap(Map<String,dynamic> map) {
    return Vinile(
      id: map['id'],
      titolo: map['titolo'],
      artista: map['artista'],
      anno: map['anno'],
      genere: map['genere'],
      etichetta: map['etichetta'],
      condizione: map['condizione'],
      copertina: map['copertina'],
      preferito: map['preferito'] == 1,
    );
  }

  @override
  String toString() {
    return 'Vinile(id: $id, titolo: $titolo, artista: $artista, anno: $anno, '
           'genere: $genere, etichetta: $etichetta, condizione: $condizione, '
           'copertina: $copertina, preferito: $preferito)';
  }
}