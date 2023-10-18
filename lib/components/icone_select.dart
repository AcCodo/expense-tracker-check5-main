import 'package:expense_tracker/models/icones_meta.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class IconeSelect extends StatelessWidget {
  final IconeMeta? icone;
  final void Function()? onTap;
  const IconeSelect({super.key, this.icone, this.onTap});

  @override
  Widget build(BuildContext context) {
    final circleAvatar = icone == null
        ? CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: const Icon(
              Ionicons.wallet_outline,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            child: Icon(icone!.icone),
          );

    return ListTile(
      leading: circleAvatar,
      title: Text(icone?.id ?? 'Selecione um Ícone'),
      trailing: const Icon(Ionicons.chevron_forward_circle_outline),
      onTap: onTap,
    );
  }
}
