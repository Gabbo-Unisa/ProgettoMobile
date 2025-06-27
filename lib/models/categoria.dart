class Categoria {
  final String id;
  final String nome;

  const Categoria({
    required this.id,
    required this.nome,
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
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