import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/sala_controller.dart';
import '../../models/sala_model.dart';
import '../../services/auth_service.dart';  // Importe o AuthService

class SalaDetalhes extends StatelessWidget {
  final SalaController salaController = Get.put(SalaController());
  final AuthService authService = Get.find<AuthService>();  // Crie uma instância do AuthService

  @override
  Widget build(BuildContext context) {
    final salaId = Get.parameters['id'];

    if (salaId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Detalhes da Sala")),
        body: Center(child: Text("ID da sala não especificado")),
      );
    }

    final sala = salaController.salas.firstWhere(
      (sala) => sala.id == salaId,
      orElse: () => Sala(
        id: "",
        nome: "Sala não encontrada",
        capacidade: 0,
        recursos: [],
        custoPorHora: 0.0,
      ),
    );

    final isCurrentUserReserver = sala.userId == authService.currentUser?.uid; // Verifique se o usuário atual é o mesmo que reservou a sala

    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Sala")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome: ${sala.nome}"),
            Text("Capacidade: ${sala.capacidade}"),
            Text("Custo por hora: ${sala.custoPorHora}"),
            Text("Recursos: ${sala.recursos.join(", ")}"),
            sala.startTime != null
                ? Text("Data de inicio: ${DateFormat('dd/MM/yyyy H:mm:ss').format(sala.startTime!)}")
                : Text("Sala disponível"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (sala.isOcupada && isCurrentUserReserver)  // Mostra o botão somente se a sala estiver reservada e o usuário atual for o reservador
            ? ElevatedButton(
                onPressed: () {
                  salaController.finalizarSala(sala);
                },
                child: Text("Finalizar Sala"),
              )
            : null,  // Se as condições não forem atendidas, não mostrará nada
      ),
    );
  }
}
