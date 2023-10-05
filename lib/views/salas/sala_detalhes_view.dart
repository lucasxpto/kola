import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sala_controller.dart';
import '../../models/sala_model.dart';

class SalaDetalhes extends StatelessWidget {
  final SalaController salaController = Get.put(SalaController());

  @override
  Widget build(BuildContext context) {
    final salaId = Get.parameters['id']; // Obtém o ID da sala da rota

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
        capacidade: 0, // add the required argument
        recursos: [], // add the required argument
        custoPorHora: 0.0, // add the required argument
      ), // Pode personalizar a mensagem
    );

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
            // Adicione mais informações da sala aqui
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Chame a função para finalizar a sala aqui
            salaController.finalizarSala(sala);
          },
          child: Text("Finalizar Sala"),
        ),
      ),
    );
  }
}
