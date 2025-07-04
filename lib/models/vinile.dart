class Vinile {
  final int? id;
  final String titolo;
  final String artista;
  final int anno;
  final String etichetta;
  final String condizione;
  final String? copertina;
  final bool preferito;
  final int? categoriaId;


  const Vinile({
    this.id,
    required this.titolo,
    required this.artista,
    required this.anno,
    required this.etichetta,
    required this.condizione,
    this.copertina,
    this.preferito = false,
    this.categoriaId,
  });

  // Converte un Vinile in una Map; le chiavi sono le colonne
  // della tabella 'vinili' nel database
  Map<String, dynamic> toMap() {
    final map = {
      'titolo': titolo,
      'artista': artista,
      'anno': anno,
      'etichetta': etichetta,
      'condizione': condizione,
      'copertina': copertina,
      'preferito': preferito ? 1 : 0,
      'categoriaId': categoriaId,
    };

    return map;
  }


  // Serve per ricreare un oggetto Vinile a partire da una riga del database
  // (che viene restituita come una Map<String, dynamic> da SQLite)
  factory Vinile.fromMap(Map<String,dynamic> map) {
    return Vinile(
      id: map['id'],
      titolo: map['titolo'],
      artista: map['artista'],
      anno: map['anno'],
      etichetta: map['etichetta'],
      condizione: map['condizione'],
      copertina: map['copertina'],
      preferito: map['preferito'] == 1,
      categoriaId: map['categoriaId'],
    );
  }

  @override
  String toString() {
    return 'Vinile(id: $id, titolo: $titolo, artista: $artista, anno: $anno, '
           'etichetta: $etichetta, condizione: $condizione, copertina: $copertina, '
           'preferito: $preferito, categoriaId: $categoriaId)';
  }
}