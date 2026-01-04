import 'package:hive_flutter/hive_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../models/vault_item.dart';

class StorageService {
  final Box<VaultItem> _box = Hive.box<VaultItem>('vault');

  // ⚠️ Demo key only — replace with secure key storage later
  final encrypt.Key _key = encrypt.Key.fromLength(32);
  final encrypt.IV _iv = encrypt.IV.fromLength(16);

  String _encryptData(String plainText) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String _decryptData(String encryptedText) {
    try {
      final encrypter = encrypt.Encrypter(
        encrypt.AES(_key, mode: encrypt.AESMode.cbc),
      );
      return encrypter.decrypt64(encryptedText, iv: _iv);
    } catch (_) {
      // If decryption fails, return original text
      return encryptedText;
    }
  }

  Future<void> saveItem(VaultItem item) async {
    final encryptedItem = VaultItem(
      id: item.id,
      title: item.title,
      content: _encryptData(item.content),
      type: item.type,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );

    await _box.put(item.id, encryptedItem);
  }

  Future<List<VaultItem>> getAllItems() async {
    return _box.values.map((VaultItem item) {
      return VaultItem(
        id: item.id,
        title: item.title,
        content: _decryptData(item.content),
        type: item.type,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );
    }).toList();
  }

  Future<void> updateItem(VaultItem item) async {
    await saveItem(item);
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }
}
