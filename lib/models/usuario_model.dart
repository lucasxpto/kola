class Usuario {
  late String id;
  late String nome;
  late List<String> historicoReservas;
  late bool isAdmin;  // Novo campo

  Usuario({
    required this.id,
    required this.nome,
    required this.historicoReservas,
    required this.isAdmin,
  });

  Usuario.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        nome = firestore['nome'],
        historicoReservas = List<String>.from(firestore['historicoReservas']),
        isAdmin = firestore['isAdmin'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'historicoReservas': historicoReservas,
      'isAdmin': isAdmin,
    };
  }
}
