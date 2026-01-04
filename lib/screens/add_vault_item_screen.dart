import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vault_provider.dart';
import '../models/vault_item.dart';

class AddVaultItemScreen extends StatefulWidget {
  const AddVaultItemScreen({super.key});

  @override
  State<AddVaultItemScreen> createState() => _AddVaultItemScreenState();
}

class _AddVaultItemScreenState extends State<AddVaultItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _type = 'password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Add Secret'),
        backgroundColor: const Color(0xFF0A0E27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(_titleController, 'Title'),
              _input(_contentController, 'Content', maxLines: 3),
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: const Color(0xFF1A1F3A),
                items: const [
                  DropdownMenuItem(
                    value: 'password',
                    child: Text('Password'),
                  ),
                  DropdownMenuItem(
                    value: 'note',
                    child: Text('Secure Note'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _type = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) =>
        value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) return;

    final item = VaultItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      type: _type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<VaultProvider>().addItem(item);

    Navigator.pop(context);
  }
}
