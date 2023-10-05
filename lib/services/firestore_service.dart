import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  // Sala
  Future<void> addSala(Map<String, dynamic> salaData) async {
    await _firestore.collection('salas').add(salaData);
  }

  Future<QuerySnapshot> getAllSalas() {
    return _firestore.collection('salas').get();
  }

  Future<DocumentSnapshot> getSalaDetails(String salaId) {
    return _firestore.collection('salas').doc(salaId).get();
  }

  Future<void> updateSalaStatus(String salaId, bool isOcupada) async {
    await _firestore
        .collection('salas')
        .doc(salaId)
        .update({'isOcupada': isOcupada});
  }

  // Reserva
  Future<void> createReserva(Map<String, dynamic> reservaData) async {
    await _firestore.collection('reservas').add(reservaData);
  }

  Future<void> finalizeReserva(
      String reservaId, Map<String, dynamic> updateData) async {
    await _firestore.collection('reservas').doc(reservaId).update(updateData);
  }

  Future<QuerySnapshot> getUserReservas(String userId) {
    return _firestore
        .collection('reservas')
        .where('userId', isEqualTo: userId)
        .get();
  }

  // Usuário
  Future<void> registerUser(Map<String, dynamic> userData) async {
    await _firestore.collection('usuarios').add(userData);
  }

  Future<DocumentSnapshot> getUserDetails(String userId) {
    return _firestore.collection('usuarios').doc(userId).get();
  }

  Future<void> updateUserPoints(String userId, int newPoints) async {
    await _firestore
        .collection('usuarios')
        .doc(userId)
        .update({'points': newPoints});
  }
}
