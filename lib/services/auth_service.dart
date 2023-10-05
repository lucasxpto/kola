import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/usuario_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtenha o usuário atual
  User? get currentUser => _auth.currentUser;

  // Registrar usuário com e-mail e senha
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Se o registro for bem-sucedido, salve o usuário no Firestore
      if (userCredential.user != null) {
        Usuario newUser = Usuario(
          id: userCredential.user!.uid,
          nome: email, // Estamos usando o e-mail como nome para simplificar
          historicoReservas: [],
          isAdmin: false, // Por padrão, novos usuários não são administradores
        );
        await _saveUserToFirestore(newUser);
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Método interno para salvar um objeto Usuario no Firestore
  Future<void> _saveUserToFirestore(Usuario user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .set(user.toMap());
  }

  // Entrar com e-mail e senha
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

Future<Usuario?> getCurrentUser() async {
  User? firebaseUser = _auth.currentUser;
  if (firebaseUser != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    return Usuario.fromFirestore(userDoc.data() as Map<String, dynamic>);
  }
  return null;
}

  // Deslogar
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
