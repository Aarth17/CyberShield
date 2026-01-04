import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/vault_item.dart';
import '../providers/vault_provider.dart';

class VaultItemCard extends StatefulWidget {
  final VaultItem item;
  const VaultItemCard({super.key, required this.item});

  @override
  State<VaultItemCard> createState() => _VaultItemCardState();
}

class _VaultItemCardState extends State<VaultItemCard> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.item.type == 'password';

    return Card(
      color: const Color(0xFF1A1F3A),
      child: ListTile(
        title: Text(widget.item.title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          isPassword && hidden ? '••••••••' : widget.item.content,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPassword)
              IconButton(
                icon: Icon(hidden ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => hidden = !hidden),
              ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: widget.item.content));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context
                    .read<VaultProvider>()
                    .deleteItem(widget.item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
