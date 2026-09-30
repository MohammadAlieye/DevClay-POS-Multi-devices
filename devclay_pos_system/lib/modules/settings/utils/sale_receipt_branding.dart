import '../domain/entities/settings_entities.dart';
import '../../sales/domain/entities/sale_entities.dart';

extension SaleReceiptBrandingX on SaleReceiptData {
  SaleReceiptData withBranding(
    ReceiptBranding branding, {
    String? operatorName,
  }) {
    return copyWith(
      title: branding.receiptTitle.isNotEmpty
          ? branding.receiptTitle
          : title,
      businessName:
          branding.showBusinessInfo ? branding.businessName : null,
      businessAddress:
          branding.showBusinessInfo ? branding.businessAddress : null,
      businessPhone:
          branding.showBusinessInfo ? branding.businessPhone : null,
      taxNumber: branding.showBusinessInfo ? branding.taxNumber : null,
      receiptFooter: branding.receiptFooter,
      receiptLogoPath: branding.showBusinessInfo
          ? branding.receiptLogoPath
          : null,
      receiptTerms: branding.receiptTerms,
      operatorName: operatorName ?? this.operatorName,
      counterName: branding.receiptCounterName,
      systemName: branding.receiptSystemName,
      fbrInvoiceEnabled: branding.fbrInvoiceEnabled,
      developerFooter: branding.developerFooterLine,
      printedAt: printedAt ?? DateTime.now(),
    );
  }
}
