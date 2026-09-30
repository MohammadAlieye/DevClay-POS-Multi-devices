import 'package:equatable/equatable.dart';

import '../../../../constants/developer_contact.dart';
import '../../../../widgets/field_limits.dart';

class AppSettingsSnapshot extends Equatable {
  const AppSettingsSnapshot({
    required this.businessName,
    required this.businessCity,
    required this.businessPhone,
    required this.businessEmail,
    required this.businessAddress,
    required this.taxNumber,
    required this.defaultTaxRate,
    required this.defaultTaxInclusive,
    this.taxEnabled = true,
    required this.receiptFooter,
    required this.showBusinessInfoOnReceipt,
    required this.receiptTitle,
    this.receiptLogoPath,
    required this.receiptTerms,
    required this.receiptCounterName,
    required this.receiptSystemName,
    required this.fbrInvoiceEnabled,
    required this.printerName,
    required this.autoPrintReceipt,
    required this.paperWidthMm,
    this.receiptContentWidthMm = 72,
    this.receiptPrintAlign = 'center',
    this.lastBackupAt,
    this.lastBackupPath,
    this.productUnits = DefaultProductUnits.all,
    this.productCategories = DefaultProductCategories.all,
    this.themeMode = 'light',
    this.accentPreset = 'ocean',
    this.primaryPreset = 'slate',
  });

  final String businessName;
  final String businessCity;
  final String businessPhone;
  final String businessEmail;
  final String businessAddress;
  final String taxNumber;
  final double defaultTaxRate;
  final bool defaultTaxInclusive;
  final bool taxEnabled;
  final String receiptFooter;
  final bool showBusinessInfoOnReceipt;
  final String receiptTitle;
  final String? receiptLogoPath;
  final String receiptTerms;
  final String receiptCounterName;
  final String receiptSystemName;
  final bool fbrInvoiceEnabled;
  final String printerName;
  final bool autoPrintReceipt;
  final int paperWidthMm;
  final int receiptContentWidthMm;
  final String receiptPrintAlign;
  final DateTime? lastBackupAt;
  final String? lastBackupPath;
  final List<String> productUnits;
  final List<String> productCategories;
  final String themeMode;
  final String accentPreset;
  final String primaryPreset;

  @override
  List<Object?> get props => [
        businessName,
        businessCity,
        businessPhone,
        businessEmail,
        businessAddress,
        taxNumber,
        defaultTaxRate,
        defaultTaxInclusive,
        taxEnabled,
        receiptFooter,
        showBusinessInfoOnReceipt,
        receiptTitle,
        receiptLogoPath,
        receiptTerms,
        receiptCounterName,
        receiptSystemName,
        fbrInvoiceEnabled,
        printerName,
        autoPrintReceipt,
        paperWidthMm,
        receiptContentWidthMm,
        receiptPrintAlign,
        lastBackupAt,
        lastBackupPath,
        productUnits,
        productCategories,
        themeMode,
        accentPreset,
        primaryPreset,
      ];
}

class AppSettingsDraft extends Equatable {
  const AppSettingsDraft({
    required this.businessName,
    required this.businessCity,
    required this.businessPhone,
    required this.businessEmail,
    required this.businessAddress,
    required this.taxNumber,
    required this.defaultTaxRate,
    required this.defaultTaxInclusive,
    this.taxEnabled = true,
    required this.receiptFooter,
    required this.showBusinessInfoOnReceipt,
    required this.receiptTitle,
    this.receiptLogoPath,
    required this.receiptTerms,
    required this.receiptCounterName,
    required this.receiptSystemName,
    required this.fbrInvoiceEnabled,
    required this.printerName,
    required this.autoPrintReceipt,
    required this.paperWidthMm,
    this.receiptContentWidthMm = 72,
    this.receiptPrintAlign = 'center',
    this.productUnits = DefaultProductUnits.all,
    this.productCategories = DefaultProductCategories.all,
    this.themeMode = 'light',
    this.accentPreset = 'ocean',
    this.primaryPreset = 'slate',
  });

  final String businessName;
  final String businessCity;
  final String businessPhone;
  final String businessEmail;
  final String businessAddress;
  final String taxNumber;
  final double defaultTaxRate;
  final bool defaultTaxInclusive;
  final bool taxEnabled;
  final String receiptFooter;
  final bool showBusinessInfoOnReceipt;
  final String receiptTitle;
  final String? receiptLogoPath;
  final String receiptTerms;
  final String receiptCounterName;
  final String receiptSystemName;
  final bool fbrInvoiceEnabled;
  final String printerName;
  final bool autoPrintReceipt;
  final int paperWidthMm;
  final int receiptContentWidthMm;
  final String receiptPrintAlign;
  final List<String> productUnits;
  final List<String> productCategories;
  final String themeMode;
  final String accentPreset;
  final String primaryPreset;

  @override
  List<Object?> get props => [
        businessName,
        businessCity,
        businessPhone,
        businessEmail,
        businessAddress,
        taxNumber,
        defaultTaxRate,
        defaultTaxInclusive,
        taxEnabled,
        receiptFooter,
        showBusinessInfoOnReceipt,
        receiptTitle,
        receiptLogoPath,
        receiptTerms,
        receiptCounterName,
        receiptSystemName,
        fbrInvoiceEnabled,
        printerName,
        autoPrintReceipt,
        paperWidthMm,
        receiptContentWidthMm,
        receiptPrintAlign,
        productUnits,
        productCategories,
        themeMode,
        accentPreset,
        primaryPreset,
      ];
}

class ReceiptBranding extends Equatable {
  const ReceiptBranding({
    required this.showBusinessInfo,
    required this.receiptTitle,
    required this.fbrInvoiceEnabled,
    this.businessName,
    this.businessAddress,
    this.businessPhone,
    this.taxNumber,
    this.receiptFooter,
    this.receiptLogoPath,
    this.receiptTerms,
    this.receiptCounterName,
    this.receiptSystemName,
  });

  final bool showBusinessInfo;
  final String receiptTitle;
  final bool fbrInvoiceEnabled;
  final String? businessName;
  final String? businessAddress;
  final String? businessPhone;
  final String? taxNumber;
  final String? receiptFooter;
  final String? receiptLogoPath;
  final String? receiptTerms;
  final String? receiptCounterName;
  final String? receiptSystemName;

  /// Fixed developer credit — never editable from Settings.
  String get developerFooterLine =>
      'Software by ${DeveloperContact.developerName} · '
      '${DeveloperContact.phoneDisplay} · ${DeveloperContact.email}';

  @override
  List<Object?> get props => [
        showBusinessInfo,
        receiptTitle,
        fbrInvoiceEnabled,
        businessName,
        businessAddress,
        businessPhone,
        taxNumber,
        receiptFooter,
        receiptLogoPath,
        receiptTerms,
        receiptCounterName,
        receiptSystemName,
      ];
}

/// Default terms seeded for new installs / cleared databases.
abstract final class DefaultReceiptTerms {
  static const String text =
      'GST included where applicable.\n'
      'No exchange without receipt.\n'
      'Exchange or store credit only — sorry, no refunds.\n'
      'Exchange within 5 days of purchase with original packing; '
      'item must be in saleable condition.\n'
      'Frozen items, electronics, books/magazines, copyable items, and '
      'items sold under promotional or discounted prices are '
      'non-exchange / non-refund.';
}
