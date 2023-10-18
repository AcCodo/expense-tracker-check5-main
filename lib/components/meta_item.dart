import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaItem extends StatelessWidget {
  final Meta meta;
  final void Function()? onTap;
  const MetaItem({Key? key, required this.meta, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final objetivo =
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.objetivo);
    final atual =
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.atual);

    return ListTile(
      leading: Icon(meta.icone),
      title: Text(meta.nome),
      subtitle: Text('$atual / $objetivo'),
      onTap: onTap,
    );
  }
}
