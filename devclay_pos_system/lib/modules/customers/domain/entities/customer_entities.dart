import 'package:equatable/equatable.dart';

class CustomerItem extends Equatable {
  const CustomerItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
    required this.creditLimit,
    required this.isActive,
    required this.totalPurchases,
    required this.receiptCount,
    this.email,
    this.address,
    this.notes,
  });

  final int id;
  final String name;
  final String phone;
  final double balance;
  final double creditLimit;
  final bool isActive;
  final double totalPurchases;
  final int receiptCount;
  final String? email;
  final String? address;
  final String? notes;

  bool get hasBalance => balance.abs() > 0.001;
  bool get customerOwesShop => balance > 0.001;
  bool get shopOwesCustomer => balance < -0.001;
  bool get isOverLimit => creditLimit > 0 && balance > creditLimit;

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    balance,
    creditLimit,
    isActive,
    totalPurchases,
    receiptCount,
    email,
    address,
    notes,
  ];
}

class CustomerDraft extends Equatable {
  const CustomerDraft({
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.notes,
    this.creditLimit = 0,
    this.isActive = true,
  });

  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? notes;
  final double creditLimit;
  final bool isActive;

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    address,
    notes,
    creditLimit,
    isActive,
  ];
}

class CustomerSaleSummary extends Equatable {
  const CustomerSaleSummary({
    required this.invoiceNo,
    required this.total,
    required this.soldAt,
    required this.paymentMethod,
  });

  final String invoiceNo;
  final double total;
  final DateTime soldAt;
  final String paymentMethod;

  @override
  List<Object?> get props => [invoiceNo, total, soldAt, paymentMethod];
}

class CustomerKhataEntry extends Equatable {
  const CustomerKhataEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.entryDate,
    this.reference,
    this.note,
  });

  final int id;
  final String type;
  final double amount;
  final double balanceAfter;
  final DateTime entryDate;
  final String? reference;
  final String? note;

  bool get isDebit => type == 'debit';

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    balanceAfter,
    entryDate,
    reference,
    note,
  ];
}
