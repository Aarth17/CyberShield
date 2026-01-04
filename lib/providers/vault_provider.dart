import 'package:flutter/material.dart';
import '../models/vault_item.dart';

class VaultProvider extends ChangeNotifier {
  final List<VaultItem> _items = [];

  List<VaultItem> get items => _items;

  void addItem(VaultItem item) {
    _items.add(item);
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearVault() {
    _items.clear();
    notifyListeners();
  }
}
