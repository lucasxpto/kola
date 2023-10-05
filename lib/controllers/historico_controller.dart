import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/historico_model.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class HistoricoController extends GetxController {
  var historicos = <HistoricoUso>[].obs;
  var isLoading = true.obs;
  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    loadHistoricos();
  }

  Future<void> loadHistoricos() async {
    isLoading.value = true;

    // Obtenha o usuário logado
    Usuario? currentUser = await authService.getCurrentUser();
    if (currentUser != null) {
      // Certifique-se de que um usuário está logado
      var historicoDocs = await FirebaseFirestore.instance
          .collection('historicos')
          .where('userId', isEqualTo: currentUser.id)
          .get();
      historicos.value = historicoDocs.docs
          .map((doc) => HistoricoUso.fromFirestore(doc))
          .toList();
    }

    isLoading.value = false;
  }
}
