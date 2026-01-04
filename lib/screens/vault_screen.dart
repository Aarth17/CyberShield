import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../widgets/vault_item_card.dart';
import 'add_vault_item_screen.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultProvider = context.watch<VaultProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Vault'),
        backgroundColor: const Color(0xFF0A0E27),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              Navigator.pop(context); // Lock vault on exit
            },
          )
        ],
      ),
      backgroundColor: const Color(0xFF0A0E27),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00F5FF),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddVaultItemScreen(),
            ),
          );
        },
      ),
      body: vaultProvider.items.isEmpty
          ? const Center(
        child: Text(
          'No secrets stored yet',
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vaultProvider.items.length,
        itemBuilder: (context, index) {
          return VaultItemCard(item: vaultProvider.items[index]);
        },
      ),
    );
  }
}
