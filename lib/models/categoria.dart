class Categoria {
  final int? id;
  final String nome;

  const Categoria({
    this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'nome': nome,
    };

    return map;
  }

  factory Categoria.fromMap(Map<String,dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
    );
  }

  @override
  String toString() {
    return 'Categoria(id: $id, nome: $nome)';
  }
}