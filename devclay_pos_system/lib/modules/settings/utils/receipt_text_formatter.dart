import 'package:intl/intl.dart';

import '../../../constants/developer_contact.dart';
import '../../sales/domain/entities/sale_entities.dart';
import '../domain/entities/settings_entities.dart';
import '../../../utils/currency_formatter.dart';
import 'sale_receipt_branding.dart';

abstract final class ReceiptTextFormatter {
  static String format({
    required SaleReceiptData receipt,
    required ReceiptBranding branding,
    int paperWidthMm = 80,
  }) {
    final width = paperWidthMm >= 80 ? 32 : 24;
    final buffer = StringBuffer();
    final dateFormat = DateFormat('EEE, dd-MMM-yyyy h:mm a');
    final stampFormat = DateFormat('dd-MMM-yyyy HH:mm:ss');
    final branded = receipt.withBranding(branding);

    void writeln(String line) => buffer.writeln(line);

    if (branding.showBusinessInfo) {
      if (branded.businessName?.isNotEmpty ?? false) {
        writeln(_center(branded.businessName!, width));
      }
      if (branded.businessAddress?.isNotEmpty ?? false) {
        writeln(_center(branded.businessAddress!, width));
      }
      if (branded.taxNumber?.isNotEmpty ?? false) {
        writeln(_center('NTN ${branded.taxNumber}', width));
      }
      if (branded.businessPhone?.isNotEmpty ?? false) {
        writeln(_center('Contact #: ${branded.businessPhone}', width));
      }
      writeln(_line(width));
    }

    writeln(_center(branded.title, width));
    writeln(_center(branded.invoiceNo, width));
    writeln(_line(width));

    if (branded.operatorName?.isNotEmpty ?? false) {
      writeln(_pair('Operator Name', branded.operatorName!, width));
    }
    writeln(
      _pair('Invoice Date', dateFormat.format(branded.soldAt), width),
    );
    writeln(
      _pair(
        'Client Name',
        branded.customerName?.isNotEmpty == true
            ? branded.customerName!
            : 'Walk-in Customer',
        width,
      ),
    );
    if (branded.counterName?.isNotEmpty ?? false) {
      writeln(_pair('Counter', branded.counterName!, width));
    }
    if (branded.systemName?.isNotEmpty ?? false) {
      writeln(_pair('System Name', branded.systemName!, width));
    }
    writeln(_line(width));
    writeln(_pair('Item', 'Qty  Amount', width));
    writeln(_line(width));

    for (final line in branded.lines) {
      writeln(line.productName);
      if (line.lineDiscount > 0) {
        writeln(
          _pair(
            '  Disc',
            '- ${CurrencyFormatter.format(line.lineDiscount)}',
            width,
          ),
        );
      }
      writeln(
        _pair(
          CurrencyFormatter.format(line.unitPrice),
          '${line.displayQuantityText}  ${CurrencyFormatter.format(line.lineTotal)}',
          width,
        ),
      );
    }

    writeln(_line(width));
    writeln(_pair('Total Item', '${branded.totalItems}', width));
    writeln(_pair('Total Qty', '${branded.totalQty}', width));
    writeln(
      _pair('Gross Amount', CurrencyFormatter.format(branded.grossAmount), width),
    );
    if (branded.discount > 0) {
      writeln(
        _pair(
          'Discount',
          '- ${CurrencyFormatter.format(branded.discount)}',
          width,
        ),
      );
    }
    if (branded.tax > 0) {
      writeln(_pair('G.S.T', CurrencyFormatter.format(branded.tax), width));
    }

    if (branded.fbrInvoiceEnabled) {
      writeln(_line(width));
      writeln('Other Charges Detail');
      writeln(
        _pair(
          'FBR POS FEE',
          CurrencyFormatter.format(branded.fbrPosFee),
          width,
        ),
      );
      writeln(
        _pair(
          'Total Charges',
          CurrencyFormatter.format(branded.fbrPosFee),
          width,
        ),
      );
    }

    writeln(
      _pair('Net Amount', CurrencyFormatter.format(branded.netAmount), width),
    );

    if (branded.fbrInvoiceEnabled) {
      writeln(_line(width));
      writeln(
        'FBR Invoice # ${branded.fbrInvoiceNo?.isNotEmpty == true ? branded.fbrInvoiceNo! : 'Pending integration'}',
      );
      writeln('FBR POS');
      writeln(
        'Verify this invoice through FBR TaxAsaan Mobile App or SMS at 9966.',
      );
    }

    writeln(_line(width));
    writeln('Payment Detail');
    writeln(
      _pair(
        branded.paymentMethod,
        CurrencyFormatter.format(branded.amountPaid),
        width,
      ),
    );
    writeln(
      _pair('Total Amount', CurrencyFormatter.format(branded.netAmount), width),
    );
    if (branded.changeAmount > 0) {
      writeln(
        _pair('Change', CurrencyFormatter.format(branded.changeAmount), width),
      );
    }

    if (branded.notes != null && branded.notes!.isNotEmpty) {
      writeln('');
      writeln(branded.notes!);
    }

    if (branded.receiptTerms?.trim().isNotEmpty ?? false) {
      writeln(_line(width));
      writeln('Terms And Conditions');
      for (final term in branded.receiptTerms!.split('\n')) {
        if (term.trim().isEmpty) continue;
        writeln(term.trim());
      }
    }

    if (branded.receiptFooter?.isNotEmpty ?? false) {
      writeln('');
      writeln(_center(branded.receiptFooter!, width));
    }

    writeln(_line(width));
    writeln(
      'Data Entry Date: ${stampFormat.format(branded.soldAt)}',
    );
    writeln(
      'Print Date: ${stampFormat.format(branded.printedAt ?? DateTime.now())}',
    );
    writeln(_line(width));
    writeln(
      _center('Software by ${DeveloperContact.developerName}', width),
    );
    writeln(_center('Phone: ${DeveloperContact.mobile}', width));
    writeln(_center('Email: ${DeveloperContact.email}', width));

    return buffer.toString().trim();
  }

  static String _center(String text, int width) {
    if (text.length >= width) return text;
    final pad = ((width - text.length) / 2).floor();
    return '${' ' * pad}$text';
  }

  static String _pair(String label, String value, int width) {
    final space = width - label.length - value.length;
    if (space >= 1) return '$label${' ' * space}$value';
    return '$label $value';
  }

  static String _line(int width) => '-' * width;
}
