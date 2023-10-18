import 'package:expense_tracker/models/icones_meta.dart';
import 'package:flutter/material.dart';

class IconeSelectPage extends StatelessWidget {
  const IconeSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final icones = iconesMap.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Ícones")),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final icone = icones[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(icone.icone),
              ),
              title: Text(icone.id),
              onTap: () {
                Navigator.of(context).pop(icone);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: icones.length),
    );
  }
}
