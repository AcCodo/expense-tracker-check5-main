import 'package:flutter/material.dart';

class DetalhesMetaPage extends StatelessWidget {
  final Map<String, dynamic> meta;

  const DetalhesMetaPage({Key? key, required this.meta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meta['nome']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${meta['nome']}'),
            Text('Valor: \$${meta['valor']}'),
            Text('Atingido: \$${meta['atingido']}'),
            // Adicionar mais informações conforme necessário
          ],
        ),
      ),
    );
  }
}
