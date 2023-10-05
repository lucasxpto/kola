import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sala_controller.dart';
import '../../models/sala_model.dart';
import 'cadastrar_sala_view.dart';
import 'editar_sala_view.dart';

class SalasPage extends StatelessWidget {
  final SalaController salaController = Get.put(SalaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gerenciar Salas")),
      body: Obx(() {
        if (salaController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (salaController.salas.isEmpty) {
          return Center(child: Text("Nenhuma sala cadastrada."));
        }

        return ListView.builder(
          itemCount: salaController.salas.length,
          itemBuilder: (context, index) {
            Sala sala = salaController.salas[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(sala.capacidade.toString()),
                backgroundColor: sala.isOcupada ? Colors.red : Colors.green,
              ),
              title: Text(sala.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Custo por hora: ${sala.custoPorHora}"),
                  Wrap(
                    spacing: 5.0,
                    children: List<Widget>.from(
                      sala.recursos.map(
                        (recurso) => Chip(
                          label: Text(recurso),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Você já tem o objeto 'sala', então pode passá-lo diretamente
                        Get.to(() => EditarSalaPage(sala: sala));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        salaController.removeSala(sala);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CadastroSalaPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
