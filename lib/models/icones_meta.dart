import 'package:flutter/material.dart';

class IconeMeta {
  final String id;
  final IconData icone;

  const IconeMeta(this.id, this.icone);
}

const Map<String, IconeMeta> iconesMap = {
  "carro": IconeMeta('carro', Icons.car_rental),
  "casa": IconeMeta('casa', Icons.home),
  "viagem": IconeMeta('viagem', Icons.airplane_ticket),
  "outros": IconeMeta('outros', Icons.wallet),
};
