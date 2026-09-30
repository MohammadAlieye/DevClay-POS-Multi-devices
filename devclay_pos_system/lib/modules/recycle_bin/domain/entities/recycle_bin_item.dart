import 'package:equatable/equatable.dart';

enum RecycleBinKind { product, heldSale, employee, staffUser }

class RecycleBinItem extends Equatable {
  const RecycleBinItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.deletedAt,
    this.imagePath,
  });

  final RecycleBinKind kind;
  final int id;
  final String title;
  final String subtitle;
  final DateTime deletedAt;
  final String? imagePath;

  @override
  List<Object?> get props => [kind, id, title, subtitle, deletedAt, imagePath];
}
