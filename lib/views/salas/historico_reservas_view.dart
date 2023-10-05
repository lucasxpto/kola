import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/sala_model.dart';

class HistoricoReservasPage extends StatelessWidget {
  final Sala sala;

  HistoricoReservasPage({required this.sala});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Histórico de Reservas")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Histórico de Reservas da Sala ${sala.nome}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sala.reservas.length,
              itemBuilder: (context, index) {
                Reserva reserva = sala.reservas[index];
                return ListTile(
                  title: Text("Data: ${reserva.data}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hora de Início: ${reserva.horaInicio}"),
                      Text("Hora de Fim: ${reserva.horaFim}"),
                      Text("Custo: ${reserva.custo}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
