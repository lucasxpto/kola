import 'package:cloud_firestore/cloud_firestore.dart';

class Sala {
  String id; // ID único para identificar a sala
  String nome; // Nome da sala
  int capacidade; // Capacidade máxima de pessoas na sala
  List<String> recursos; // Lista de recursos disponíveis, como projetor, videoconferência, etc.
  double custoPorHora; // Custo por hora de utilização
  bool isOcupada; // Status atual da sala: disponível ou ocupada
  final String? userId; // ID do usuário que reservou a sala
  final DateTime? startTime; // Quando a sala foi ativada

  // Construtor da Sala
  Sala({
    required this.id,
    required this.nome,
    required this.capacidade,
    required this.recursos,
    required this.custoPorHora,
    this.isOcupada = false, // Por padrão, a sala é considerada disponível
    this.userId,
    this.startTime,
  });

  // Método para converter um documento do Firestore em um objeto Sala
  factory Sala.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Sala(
      id: doc.id,
      nome: data['nome'],
      capacidade: data['capacidade'],
      recursos: List<String>.from(data['recursos'] ?? []),
      custoPorHora: data['custoPorHora'],
      isOcupada: data['isOcupada'] ?? false,
      userId: data['userId'],
      startTime: data['startTime']?.toDate(),
    );
  }

  // Método para converter o objeto Sala em um Map para armazenamento no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'capacidade': capacidade,
      'recursos': recursos,
      'custoPorHora': custoPorHora,
      'isOcupada': isOcupada,
    };
  }

  Sala copyWith({
  bool? isOcupada,
  String? userId,
  DateTime? startTime,
  // Adicione outros campos conforme necessário
}) {
  return Sala(
    id: id, 
    nome: nome,
    capacidade: capacidade,
    custoPorHora: custoPorHora,
    recursos: recursos,
    isOcupada: isOcupada ?? this.isOcupada,
    userId: userId ?? this.userId,
    startTime: startTime ?? this.startTime,
    // Adicione os outros campos conforme necessário, mantendo a mesma lógica
  );
}


}
