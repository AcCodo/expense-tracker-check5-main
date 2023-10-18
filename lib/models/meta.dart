import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Meta {
  int id;
  String nome;
  IconData? icone;
  final num objetivo;
  num atual;

  Meta(
      {required this.id,
      required this.nome,
      this.icone,
      required this.objetivo,
      this.atual = 0});

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
        id: map['id'],
        nome: map['nome'],
        icone: map['icone'] == 0
            ? Ionicons.wallet
            : IconData(map['icone'], fontFamily: 'MaterialIcons'),
        objetivo: map['objetivo'],
        atual: map['atual'] ?? 0);
  }
}
