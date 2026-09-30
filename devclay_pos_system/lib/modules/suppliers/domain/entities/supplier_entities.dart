import 'package:equatable/equatable.dart';

export '../../../purchases/domain/entities/purchase_entities.dart'
    show SupplierDraft, SupplierItem;

class SupplierProfile extends Equatable {
  const SupplierProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.purchaseCount,
    required this.totalPurchased,
    required this.totalDue,
    required this.balance,
    required this.createdAt,
    this.email,
    this.address,
    this.notes,
    this.lastPurchaseDate,
  });

  final int id;
  final String name;
  final String phone;
  final bool isActive;
  final int purchaseCount;
  final double totalPurchased;
  final double totalDue;
  final double balance;
  final DateTime createdAt;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime? lastPurchaseDate;

  bool get hasDue => totalDue > 0;

  double get invoiceDue => totalDue - balance;

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        isActive,
        purchaseCount,
        totalPurchased,
        totalDue,
        balance,
        createdAt,
        email,
        address,
        notes,
        lastPurchaseDate,
      ];
}

class SupplierPurchaseSummary extends Equatable {
  const SupplierPurchaseSummary({
    required this.id,
    required this.invoiceNo,
    required this.total,
    required this.dueAmount,
    required this.purchaseDate,
    required this.status,
  });

  final int id;
  final String invoiceNo;
  final double total;
  final double dueAmount;
  final DateTime purchaseDate;
  final String status;

  bool get isPaid => dueAmount <= 0;

  @override
  List<Object?> get props =>
      [id, invoiceNo, total, dueAmount, purchaseDate, status];
}
