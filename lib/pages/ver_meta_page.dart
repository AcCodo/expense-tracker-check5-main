import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisualizarMetaPage extends StatefulWidget {
  const VisualizarMetaPage({super.key});

  @override
  State<VisualizarMetaPage> createState() => _VisualizarMetaPageState();
}

class _VisualizarMetaPageState extends State<VisualizarMetaPage> {
  @override
  Widget build(BuildContext context) {
    final meta = ModalRoute.of(context)!.settings.arguments as Meta;

    return Scaffold(
      appBar: AppBar(title: Text(meta.nome)),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
            title: const Text('Objetivo'),
            subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                .format(meta.objetivo)),
          ),
          LinearProgressIndicator(
            value: meta.atual / meta.objetivo,
            minHeight: 20,
          ),
          ListTile(
            title: const Text('Alcançado'),
            subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                .format(meta.atual)),
          )
        ],
      )),
    );
  }
}
