import 'dart:convert';

class LanHealthDto {
  const LanHealthDto({
    required this.ok,
    required this.businessName,
    required this.storeProfile,
    required this.apiVersion,
    required this.serverTime,
  });

  final bool ok;
  final String businessName;
  final String storeProfile;
  final String apiVersion;
  final String serverTime;

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'businessName': businessName,
        'storeProfile': storeProfile,
        'apiVersion': apiVersion,
        'serverTime': serverTime,
      };

  factory LanHealthDto.fromJson(Map<String, dynamic> json) => LanHealthDto(
        ok: json['ok'] == true,
        businessName: '${json['businessName'] ?? ''}',
        storeProfile: '${json['storeProfile'] ?? ''}',
        apiVersion: '${json['apiVersion'] ?? '1'}',
        serverTime: '${json['serverTime'] ?? ''}',
      );
}

class LanProfileDto {
  const LanProfileDto({
    required this.storeProfile,
    required this.storeProfileConfigured,
    required this.enableBatchesExpiry,
    required this.batchesExpiryRequired,
    required this.enableProductVariants,
    required this.enableVariableMeasureSales,
    required this.preferVolumeUnits,
    required this.productCategoriesCsv,
    required this.productUnitsCsv,
    required this.preferredLabelStoreType,
  });

  final String storeProfile;
  final bool storeProfileConfigured;
  final bool enableBatchesExpiry;
  final bool batchesExpiryRequired;
  final bool enableProductVariants;
  final bool enableVariableMeasureSales;
  final bool preferVolumeUnits;
  final String productCategoriesCsv;
  final String productUnitsCsv;
  final String preferredLabelStoreType;

  Map<String, dynamic> toJson() => {
        'storeProfile': storeProfile,
        'storeProfileConfigured': storeProfileConfigured,
        'enableBatchesExpiry': enableBatchesExpiry,
        'batchesExpiryRequired': batchesExpiryRequired,
        'enableProductVariants': enableProductVariants,
        'enableVariableMeasureSales': enableVariableMeasureSales,
        'preferVolumeUnits': preferVolumeUnits,
        'productCategoriesCsv': productCategoriesCsv,
        'productUnitsCsv': productUnitsCsv,
        'preferredLabelStoreType': preferredLabelStoreType,
      };

  factory LanProfileDto.fromJson(Map<String, dynamic> json) => LanProfileDto(
        storeProfile: '${json['storeProfile'] ?? ''}',
        storeProfileConfigured: json['storeProfileConfigured'] == true,
        enableBatchesExpiry: json['enableBatchesExpiry'] != false,
        batchesExpiryRequired: json['batchesExpiryRequired'] == true,
        enableProductVariants: json['enableProductVariants'] == true,
        enableVariableMeasureSales: json['enableVariableMeasureSales'] != false,
        preferVolumeUnits: json['preferVolumeUnits'] == true,
        productCategoriesCsv: '${json['productCategoriesCsv'] ?? ''}',
        productUnitsCsv: '${json['productUnitsCsv'] ?? ''}',
        preferredLabelStoreType: '${json['preferredLabelStoreType'] ?? 'retail'}',
      );
}

class LanAuthUserDto {
  const LanAuthUserDto({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.permissions,
  });

  final int id;
  final String username;
  final String displayName;
  final String role;
  final List<String> permissions;

  factory LanAuthUserDto.fromJson(Map<String, dynamic> json) => LanAuthUserDto(
        id: (json['id'] as num?)?.toInt() ?? 0,
        username: '${json['username'] ?? ''}',
        displayName: '${json['displayName'] ?? ''}',
        role: '${json['role'] ?? ''}',
        permissions: (json['permissions'] as List?)
                ?.map((e) => '$e')
                .toList(growable: false) ??
            const [],
      );
}

class LanCreateSaleDto {
  const LanCreateSaleDto({
    required this.linesJson,
    required this.cashierId,
    required this.cashierName,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.discount,
    required this.paymentMethod,
    required this.amountPaid,
    required this.cardAmount,
    required this.changeAmount,
    required this.itemCount,
    this.customerId,
    this.customerName,
    this.notes,
    this.cashAccountId,
    this.bankAccountId,
    this.methodKind = 'cash',
  });

  final String linesJson;
  final int cashierId;
  final String cashierName;
  final double subtotal;
  final double tax;
  final double total;
  final double discount;
  final String paymentMethod;
  final double amountPaid;
  final double cardAmount;
  final double changeAmount;
  final int itemCount;
  final int? customerId;
  final String? customerName;
  final String? notes;
  final int? cashAccountId;
  final int? bankAccountId;
  final String methodKind;

  Map<String, dynamic> toJson() => {
        'linesJson': linesJson,
        'cashierId': cashierId,
        'cashierName': cashierName,
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'discount': discount,
        'paymentMethod': paymentMethod,
        'amountPaid': amountPaid,
        'cardAmount': cardAmount,
        'changeAmount': changeAmount,
        'itemCount': itemCount,
        'customerId': customerId,
        'customerName': customerName,
        'notes': notes,
        'cashAccountId': cashAccountId,
        'bankAccountId': bankAccountId,
        'methodKind': methodKind,
      };

  factory LanCreateSaleDto.fromJson(Map<String, dynamic> json) =>
      LanCreateSaleDto(
        linesJson: '${json['linesJson'] ?? '[]'}',
        cashierId: (json['cashierId'] as num?)?.toInt() ?? 0,
        cashierName: '${json['cashierName'] ?? ''}',
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        tax: (json['tax'] as num?)?.toDouble() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
        paymentMethod: '${json['paymentMethod'] ?? 'cash'}',
        amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0,
        cardAmount: (json['cardAmount'] as num?)?.toDouble() ?? 0,
        changeAmount: (json['changeAmount'] as num?)?.toDouble() ?? 0,
        itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
        customerId: (json['customerId'] as num?)?.toInt(),
        customerName: json['customerName'] as String?,
        notes: json['notes'] as String?,
        cashAccountId: (json['cashAccountId'] as num?)?.toInt(),
        bankAccountId: (json['bankAccountId'] as num?)?.toInt(),
        methodKind: '${json['methodKind'] ?? 'cash'}',
      );

  String encode() => jsonEncode(toJson());
}
