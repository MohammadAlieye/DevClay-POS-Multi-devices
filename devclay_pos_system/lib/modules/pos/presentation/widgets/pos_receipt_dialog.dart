import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../services/hardware/receipt_print_service.dart';
import '../../../../widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../sales/domain/entities/sale_entities.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../../settings/utils/sale_receipt_branding.dart';
import '../../../../widgets/sale_receipt_dialog.dart';
import '../../domain/entities/pos_entities.dart';

Future<void> showReceiptPreview(
  BuildContext context,
  CompletedSale sale,
) async {
  final operatorName = context
      .read<AuthBloc>()
      .state
      .sessionOrNull
      ?.user
      .displayName;
  final settingsRepo = sl<SettingsRepository>();
  final settings = await settingsRepo.getSettings();
  final branding = settingsRepo.receiptBranding(settings);

  final receipt = SaleReceiptData(
    invoiceNo: sale.invoiceNo,
    lines: sale.lines
        .map(
          (line) => SaleLineItem(
            productId: line.product.id,
            productName: line.product.name,
            productSku: line.product.sku,
            quantity: line.quantity,
            unitPrice: line.product.sellingPrice,
            lineDiscount: line.discountAmount,
            lineTotal: line.lineTotal,
            batchAllocations: line.batchAllocations,
            itemsPerBox: line.product.itemsPerBox,
          ),
        )
        .toList(),
    subtotal: sale.totals.subtotal,
    discount: sale.totals.discount,
    tax: sale.totals.tax,
    total: sale.totals.total,
    paymentMethod: sale.paymentMethod,
    amountPaid: sale.amountPaid,
    changeAmount: sale.change,
    soldAt: sale.completedAt,
    customerName: sale.customerName,
    notes: sale.notes,
    title: branding.receiptTitle,
    showSuccessIcon: true,
  ).withBranding(branding, operatorName: operatorName);

  if (settings.autoPrintReceipt) {
    try {
      await ReceiptPrintService.printSaleReceipt(
        receipt: receipt,
        branding: branding,
        printerName: settings.printerName,
        paperWidthMm: settings.paperWidthMm,
        showDialogFallback: true,
      );
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, 'Print failed: $error');
      }
    }
  }

  if (!context.mounted) return;
  await showSaleReceiptDialog(
    context,
    receipt,
    onPrint: () async {
      try {
        await ReceiptPrintService.printSaleReceipt(
          receipt: receipt,
          branding: branding,
          printerName: settings.printerName,
          paperWidthMm: settings.paperWidthMm,
        );
        if (context.mounted) {
          AppToast.show(context, 'Receipt sent to printer');
        }
      } catch (error) {
        if (context.mounted) {
          AppToast.show(context, 'Print failed: $error');
        }
      }
    },
  );
}
