import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sala_controller.dart';

class SalaDetalhesPage extends StatelessWidget {
  final SalaController salaController = Get.find<SalaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salas Reservadas"),
      ),
      body: Obx(() {
        final salasReservadas = salaController.salas.where((sala) => sala.isOcupada).toList();
        return ListView.builder(
          itemCount: salasReservadas.length,
          itemBuilder: (context, index) {
            var sala = salasReservadas[index];
            return ListTile(
              title: Text(sala.nome),
              subtitle: Text(
                "Capacidade: ${sala.capacidade} - Custo por hora: ${sala.custoPorHora}",
              ),
              trailing: ElevatedButton(
                child: Text("Finalizar",
                    style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.orange),
                onPressed: () {
                  salaController.finalizarSala(sala);
                  Get.snackbar('Finalização', 'Sala finalizada com sucesso!',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
