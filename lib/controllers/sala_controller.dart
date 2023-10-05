import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/sala_model.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class SalaController extends GetxController {
  var salas = <Sala>[].obs;
  var isLoading = true.obs;
  final AuthService authService = Get.find<AuthService>();

  List<String> get recursosDisponiveis => [
        "Projetor",
        "TV",
        "Ar Condicionado",
        "Cadeiras",
        "Mesas",
        "Wi-Fi",
      ];

  @override
  void onInit() {
    super.onInit();
    loadSalas();
  }

  Future<void> loadSalas() async {
    isLoading.value = true;
    var salaDocs = await FirebaseFirestore.instance.collection('salas').get();
    salas.value = salaDocs.docs.map((doc) => Sala.fromFirestore(doc)).toList();
    isLoading.value = false;
  }

  Future<void> addSala(Sala sala) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('salas')
          .doc(sala.id)
          .set(sala.toMap());
      await loadSalas();
    } catch (e) {
      print("Erro ao salvar sala: $e");
    } finally {
      isLoading(false);
      Get.back();
    }
  }

  Future<void> saveSala({
    required String nome,
    required String capacidade,
    required String custoPorHora,
    required List<String> recursos,
  }) async {
    if (nome.isNotEmpty && capacidade.isNotEmpty && custoPorHora.isNotEmpty) {
      Sala novaSala = Sala(
        id: FirebaseFirestore.instance.collection('salas').doc().id,
        nome: nome,
        capacidade: int.parse(capacidade),
        custoPorHora: double.parse(custoPorHora),
        recursos: recursos,
      );
      await addSala(novaSala);
      Get.back();
    } else {
      if (kDebugMode) {
        print("Dados inválidos");
      }
      // Use o Get.snackbar ou outro método para mostrar ao usuário que os dados são inválidos
    }
  }

  Future<void> updateSala(Sala sala) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('salas')
          .doc(sala.id)
          .update(sala.toMap());
      await loadSalas();
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao atualizar sala: $e");
      }
    } finally {
      isLoading(false);
      Get.back();
    }
  }

  Future<void> removeSala(Sala sala) async {
    if (sala.isOcupada) {
      Get.snackbar('Erro', 'Não é possível remover uma sala ocupada.');
      return;
    }

    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('salas')
          .doc(sala.id)
          .delete();
      salas.remove(sala);
      Get.snackbar(
          'Sucesso', 'Sala removida com sucesso.'); // Mensagem de sucesso
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao remover sala: $e");
      }
      Get.snackbar('Erro', 'Ocorreu um erro ao tentar remover a sala.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> reservarSala(Sala sala) async {
    try {
      isLoading(true);
      Usuario? currentUser = await authService.getCurrentUser();
      await FirebaseFirestore.instance.collection('salas').doc(sala.id).update({
        'isOcupada': true,
        'startTime': FieldValue.serverTimestamp(),
        'userId': currentUser?.id ?? 'Unknown',
      }); // Altera o campo para indicar que a sala está ocupada.
      await loadSalas();
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao reservar sala: $e");
      }
      // Mostra uma mensagem de erro ao usuário com Get.snackbar ou outro método.
    } finally {
      isLoading(false);
    }
  }
    Future<void> finalizarSala(Sala sala) async {
      final DateTime now = DateTime.now();
      final int hoursUsed = now.difference(sala.startTime!).inHours;

      final double totalCost = hoursUsed * sala.custoPorHora;

      // Atualize a sala para marcar como não ocupada e limpe os campos relacionados à reserva
      Sala salaFinalizada =
          sala.copyWith(isOcupada: false, userId: null, startTime: null);

      try {
        // Atualize a sala no Firestore
        await FirebaseFirestore.instance
            .collection('salas')
            .doc(salaFinalizada.id)
            .update(salaFinalizada.toMap());

        await FirebaseFirestore.instance.collection('historicos').add({
          'salaId': sala.id,
          'salaNome': sala.nome,
          'userId': sala.userId,
          'startTime': sala.startTime,
          'endTime': DateTime.now(),
          'custo': totalCost
        });

        // Recarregue a lista de salas após a atualização
        await loadSalas();

        // Navegue para a tela de histórico do usuário
        Get.toNamed('/historico');
      } catch (e) {
        // Trate qualquer erro aqui
        if (kDebugMode) {
          print("Erro ao finalizar sala: $e");
        }
      }
    }
  }