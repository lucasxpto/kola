import 'package:cloud_firestore/cloud_firestore.dart';

class HistoricoUso {
  final String id; 
  final String salaId;
  final String salaNome;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final double custo;

  HistoricoUso({
    required this.id,
    required this.salaId,
    required this.salaNome,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.custo,
  });

  factory HistoricoUso.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HistoricoUso(
      id: doc.id,
      salaId: data['salaId'],
      salaNome: data['salaNome'],
      userId: data['userId'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      custo: data['custo'].toDouble(),
    );
}
}


