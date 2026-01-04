import 'package:hive/hive.dart';

part 'vault_item.g.dart';

@HiveType(typeId: 0) // 👈 MUST BE 0 (matches adapter)
class VaultItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  VaultItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });
}
