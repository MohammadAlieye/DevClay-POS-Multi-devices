/// A printer advertised by the operating system (Windows spooler, etc.).
class DiscoveredPrinter {
  const DiscoveredPrinter({
    required this.name,
    required this.url,
    this.model,
    this.location,
    this.isDefault = false,
    this.isAvailable = true,
  });

  final String name;
  final String url;
  final String? model;
  final String? location;
  final bool isDefault;
  final bool isAvailable;

  bool matchesPreferredName(String preferred) {
    final needle = preferred.trim().toLowerCase();
    if (needle.isEmpty) return false;
    return name.toLowerCase() == needle ||
        url.toLowerCase() == needle ||
        name.toLowerCase().contains(needle);
  }
}

/// How the cash drawer is linked for status display.
///
/// Most POS drawers connect to the receipt printer's DK (RJ11) port and cannot
/// report open/closed state — readiness follows the selected printer.
enum CashDrawerLinkState {
  /// Selected receipt printer is available; drawer kick can be sent.
  ready,

  /// A printer is selected/matched but reported offline.
  printerOffline,

  /// No receipt printer selected or found.
  noPrinter,

  /// Platform cannot send drawer-kick commands.
  unsupported,
}

/// Cash drawer readiness derived from the receipt printer link.
class CashDrawerStatus {
  const CashDrawerStatus({
    required this.state,
    required this.detail,
    this.printerName,
  });

  final CashDrawerLinkState state;
  final String detail;
  final String? printerName;

  String get label => switch (state) {
    CashDrawerLinkState.ready => 'Ready',
    CashDrawerLinkState.printerOffline => 'Printer offline',
    CashDrawerLinkState.noPrinter => 'No printer',
    CashDrawerLinkState.unsupported => 'Unavailable',
  };

  bool get isReady => state == CashDrawerLinkState.ready;
}

/// Snapshot of peripherals the POS can currently see.
class HardwareDevicesSnapshot {
  const HardwareDevicesSnapshot({
    required this.printers,
    this.preferredPrinterName,
    this.cashDrawer = const CashDrawerStatus(
      state: CashDrawerLinkState.noPrinter,
      detail: 'Select a receipt printer to use the cash drawer',
    ),
    this.error,
  });

  final List<DiscoveredPrinter> printers;
  final String? preferredPrinterName;
  final CashDrawerStatus cashDrawer;
  final String? error;

  DiscoveredPrinter? get matchedPrinter {
    final preferred = preferredPrinterName?.trim() ?? '';
    if (preferred.isEmpty) {
      for (final printer in printers) {
        if (printer.isDefault) return printer;
      }
      return printers.isEmpty ? null : printers.first;
    }
    for (final printer in printers) {
      if (printer.matchesPreferredName(preferred)) return printer;
    }
    return null;
  }

  bool get hasPreferredPrinter => matchedPrinter != null;

  bool get preferredPrinterOnline => matchedPrinter?.isAvailable ?? false;

  /// Builds cash-drawer status from the matched receipt printer.
  static CashDrawerStatus cashDrawerFor({
    required DiscoveredPrinter? printer,
    required bool supportedOnPlatform,
  }) {
    if (!supportedOnPlatform) {
      return const CashDrawerStatus(
        state: CashDrawerLinkState.unsupported,
        detail: 'Cash drawer kick is supported on Windows',
      );
    }
    if (printer == null) {
      return const CashDrawerStatus(
        state: CashDrawerLinkState.noPrinter,
        detail: 'Select a receipt printer — drawers kick via the printer port',
      );
    }
    if (!printer.isAvailable) {
      return CashDrawerStatus(
        state: CashDrawerLinkState.printerOffline,
        detail: 'Printer offline: ${printer.name}',
        printerName: printer.name,
      );
    }
    return CashDrawerStatus(
      state: CashDrawerLinkState.ready,
      detail: 'Via printer: ${printer.name}',
      printerName: printer.name,
    );
  }
}
