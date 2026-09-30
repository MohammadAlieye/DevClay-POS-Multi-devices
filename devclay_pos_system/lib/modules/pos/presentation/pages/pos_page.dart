import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_shadows.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../../customers/domain/repositories/customers_repository.dart';
import '../../../customers/presentation/widgets/customer_editor_sheet.dart';
import '../../domain/entities/pos_entities.dart';
import '../bloc/pos_bloc.dart';
import '../utils/barcode_scan_buffer.dart';
import '../utils/pos_ui_prefs.dart';
import '../widgets/pos_cart_panel.dart';
import '../widgets/pos_payment_sheet.dart';
import '../widgets/pos_product_grid.dart';
import '../widgets/pos_receipt_dialog.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PosBloc>()..add(const PosStarted()),
      child: BlocListener<NotificationsCubit, NotificationsState>(
        listenWhen: (previous, current) =>
            previous.undoRevision != current.undoRevision &&
            (current.lastUndoActionType == NotificationTypes.restoreProduct ||
                current.lastUndoActionType ==
                    NotificationTypes.restoreHeldSale),
        listener: (context, state) {
          context.read<PosBloc>().add(const PosCatalogRefreshRequested());
        },
        child: const _PosView(),
      ),
    );
  }
}

class _PosView extends StatelessWidget {
  const _PosView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PosBloc, PosState>(
      listenWhen: (previous, current) {
        if (current is! PosReady) return false;
        if (previous is! PosReady) {
          return current.checkoutOpen ||
              current.lastSale != null ||
              current.message != null;
        }
        return (current.checkoutOpen && !previous.checkoutOpen) ||
            current.lastSale != previous.lastSale ||
            (current.message != null && current.message != previous.message);
      },
      listener: (context, state) async {
        if (state is! PosReady) return;

        if (state.checkoutOpen) {
          await showPosPaymentSheet(context, state);
          if (!context.mounted) return;
          final latest = context.read<PosBloc>().state;
          if (latest is PosReady && latest.checkoutOpen) {
            context.read<PosBloc>().add(const PosCheckoutClosed());
          }
          return;
        }

        if (state.lastSale != null) {
          await showReceiptPreview(context, state.lastSale!);
          if (context.mounted) {
            context.read<PosBloc>().add(const PosDismissMessage());
          }
          return;
        }

        // Status messages (e.g. held bill removed) render as a top-left box.
      },
      builder: (context, state) {
        return switch (state) {
          PosInitial() ||
          PosLoading() => const Center(child: CircularProgressIndicator()),
          PosError(:final message) => EmptyState(
            title: 'POS unavailable',
            message: message,
            icon: Symbols.point_of_sale,
            action: AppButton(
              label: 'Retry',
              onPressed: () => context.read<PosBloc>().add(const PosStarted()),
            ),
          ),
          PosReady() => _PosReadyView(state: state),
        };
      },
    );
  }
}

class _PosReadyView extends StatefulWidget {
  const _PosReadyView({required this.state});

  final PosReady state;

  @override
  State<_PosReadyView> createState() => _PosReadyViewState();
}

class _PosReadyViewState extends State<_PosReadyView> {
  late final TextEditingController _searchController;
  late final FocusNode _scanFocus;
  late final FocusNode _searchFocus;
  late final FocusNode _customerFocus;
  late final FocusNode _notesFocus;
  late final FocusNode _discountFocus;
  late final TextEditingController _customerController;
  late final TextEditingController _notesController;
  late final TextEditingController _discountController;
  late final BarcodeScanBuffer _scanBuffer;
  String? _scheduledMessage;
  bool _toolsOpen = PosUiPrefs.instance.toolsOpen;
  bool _metaExpanded = PosUiPrefs.instance.metaExpanded;
  double _cartWidthFraction = PosUiPrefs.instance.cartWidthFraction;
  PosProductLayout _productLayout = PosProductLayout.grid;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.query);
    _scanFocus = FocusNode(debugLabel: 'pos-barcode-scan');
    _searchFocus = FocusNode(debugLabel: 'pos-search');
    _customerFocus = FocusNode();
    _notesFocus = FocusNode();
    _discountFocus = FocusNode();
    _customerController = TextEditingController(
      text: widget.state.customerName ?? '',
    );
    _notesController = TextEditingController(text: widget.state.notes ?? '');
    _discountController = TextEditingController(
      text: widget.state.cartDiscount > 0
          ? _discountFieldLabel(
              widget.state.cartDiscount,
              widget.state.cartDiscountMode,
            )
          : '',
    );
    _scanBuffer = BarcodeScanBuffer(onScan: _handleScannedCode);
    HardwareKeyboard.instance.addHandler(_onHardwareKey);
    for (final node in [
      _searchFocus,
      _customerFocus,
      _notesFocus,
      _discountFocus,
    ]) {
      node.addListener(() {
        if (node.hasFocus) _scanBuffer.clear();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureScanFocus());
    _scheduleMessageDismiss(widget.state.message);
    _loadUiPrefs();
  }

  Future<void> _loadUiPrefs() async {
    await PosUiPrefs.instance.load();
    if (!mounted) return;
    setState(() {
      _toolsOpen = PosUiPrefs.instance.toolsOpen;
      _metaExpanded = PosUiPrefs.instance.metaExpanded;
      _cartWidthFraction = PosUiPrefs.instance.cartWidthFraction;
    });
  }

  Future<void> _setToolsOpen(bool open) async {
    setState(() => _toolsOpen = open);
    await PosUiPrefs.instance.setToolsOpen(open);
    if (open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _searchFocus.requestFocus();
      });
    } else {
      _searchFocus.unfocus();
      _ensureScanFocus();
    }
  }

  Future<void> _setMetaExpanded(bool expanded) async {
    setState(() => _metaExpanded = expanded);
    await PosUiPrefs.instance.setMetaExpanded(expanded);
    if (!expanded) _ensureScanFocus();
  }

  Future<void> _addCustomer() async {
    final draft = await showCustomerEditorSheet(
      context: context,
      initialName: _customerController.text.trim(),
    );
    if (draft == null || !mounted) return;
    try {
      final saved = await sl<CustomersRepository>().saveCustomer(draft);
      if (!mounted) return;
      context.read<PosBloc>().add(
        PosCustomerCreated(
          PosCustomer(
            id: saved.id,
            name: saved.name,
            phone: saved.phone,
            balance: saved.balance,
          ),
        ),
      );
    } catch (error) {
      if (mounted) AppToast.show(context, userFacingError(error));
    }
  }

  @override
  void didUpdateWidget(covariant _PosReadyView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final state = widget.state;
    if (state.message != oldWidget.state.message) {
      _scheduleMessageDismiss(state.message);
    }
    if (state.query != _searchController.text) {
      _searchController.value = TextEditingValue(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
      );
    }
    final nextCustomer = state.customerName ?? '';
    if (nextCustomer != _customerController.text) {
      _customerController.value = TextEditingValue(
        text: nextCustomer,
        selection: TextSelection.collapsed(offset: nextCustomer.length),
      );
    }
    final nextNotes = state.notes ?? '';
    if (nextNotes != _notesController.text) {
      _notesController.value = TextEditingValue(
        text: nextNotes,
        selection: TextSelection.collapsed(offset: nextNotes.length),
      );
    }
    if (state.cartDiscountMode != oldWidget.state.cartDiscountMode) {
      _discountController.clear();
    } else if (state.cartDiscount == 0 && _discountController.text.isNotEmpty) {
      _discountController.clear();
    } else {
      final nextDiscount = state.cartDiscount > 0
          ? _discountFieldLabel(state.cartDiscount, state.cartDiscountMode)
          : '';
      if (nextDiscount != _discountController.text) {
        _discountController.value = TextEditingValue(
          text: nextDiscount,
          selection: TextSelection.collapsed(offset: nextDiscount.length),
        );
      }
    }

    if (!state.checkoutOpen &&
        oldWidget.state.lines != state.lines &&
        !_editingTextField) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureScanFocus());
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onHardwareKey);
    _scanBuffer.dispose();
    _searchController.dispose();
    _scanFocus.dispose();
    _searchFocus.dispose();
    _customerFocus.dispose();
    _notesFocus.dispose();
    _discountFocus.dispose();
    _customerController.dispose();
    _notesController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  bool get _editingSideField =>
      _customerFocus.hasFocus ||
      _notesFocus.hasFocus ||
      _discountFocus.hasFocus;

  /// True while any text field owns focus, including transient ones such as
  /// the inline cart price editor. The scan buffer must never swallow those
  /// keystrokes.
  bool get _editingTextField =>
      _searchFocus.hasFocus || _editingSideField || _focusIsTextInput;

  bool get _focusIsTextInput {
    final context = FocusManager.instance.primaryFocus?.context;
    if (context == null) return false;
    if (context.widget is EditableText) return true;
    return context.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  void _scheduleMessageDismiss(String? message) {
    _scheduledMessage = message;
    if (message == null) return;
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      if (_scheduledMessage != message) return;
      final current = context.read<PosBloc>().state;
      if (current is PosReady && current.message == message) {
        context.read<PosBloc>().add(const PosDismissMessage());
      }
    });
  }

  void _ensureScanFocus() {
    if (!mounted || widget.state.checkoutOpen) return;
    if (_editingTextField) return;
    if (_scanFocus.hasPrimaryFocus) return;
    _scanFocus.requestFocus();
  }

  void _onBackgroundTap() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ensureScanFocus();
    });
  }

  /// Fallback when focus is on the product grid / chips (not a text field).
  /// Scan focus [Focus.onKeyEvent] handles the normal path.
  bool _onHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (widget.state.checkoutOpen) return false;
    if (_editingTextField) return false;
    if (_scanFocus.hasPrimaryFocus) return false;

    if (BarcodeScanBuffer.isTerminator(event)) {
      if (_scanBuffer.hasPending) {
        _scanBuffer.commit(fromTerminator: true);
        return true;
      }
      return _tryOpenPayWithEnter(event);
    }

    final character = BarcodeScanBuffer.characterFor(event);
    if (character == null) return false;
    _scanBuffer.addCharacter(character);
    return true;
  }

  KeyEventResult _onScanKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (widget.state.checkoutOpen) return KeyEventResult.ignored;
    // Let search / customer fields receive keyboard input.
    if (_editingTextField) return KeyEventResult.ignored;

    if (BarcodeScanBuffer.isTerminator(event)) {
      if (_scanBuffer.hasPending) {
        _scanBuffer.commit(fromTerminator: true);
        return KeyEventResult.handled;
      }
      return _tryOpenPayWithEnter(event)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }

    final character = BarcodeScanBuffer.characterFor(event);
    if (character == null) return KeyEventResult.ignored;

    _scanBuffer.addCharacter(character);
    return KeyEventResult.handled;
  }

  /// Empty Enter (no barcode pending) opens Pay when the cart has items.
  bool _tryOpenPayWithEnter(KeyEvent event) {
    final isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter) return false;
    if (widget.state.lines.isEmpty) return false;
    context.read<PosBloc>().add(const PosCheckoutRequested());
    return true;
  }

  void _handleScannedCode(String code) {
    if (!mounted) return;
    // Keep search box clean — scans never belong there.
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      context.read<PosBloc>().add(const PosSearchChanged(''));
    }
    context.read<PosBloc>().add(PosScanSubmitted(code));
    // Drop search focus so the next scan is not typed into the box.
    _searchFocus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureScanFocus());
  }

  void _onSearchChanged(String value) {
    context.read<PosBloc>().add(PosSearchChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);
    final categories = ['All', ...state.categories];
    final isDark = theme.brightness == Brightness.dark;

    return _buildPosLayout(
      context: context,
      state: state,
      theme: theme,
      categories: categories,
      isDark: isDark,
    );
  }

  Widget _buildPosLayout({
    required BuildContext context,
    required PosReady state,
    required ThemeData theme,
    required List<String> categories,
    required bool isDark,
  }) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0B1220), Color(0xFF121A2A)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF5F8FC), Color(0xFFEEF3FA)],
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const handleWidth = 10.0;
                const minCatalog = 320.0;
                const minCart = 300.0;
                final maxCart = (constraints.maxWidth - handleWidth - minCatalog)
                    .clamp(minCart, constraints.maxWidth * 0.55);
                final cartWidth =
                    ((constraints.maxWidth * _cartWidthFraction) - handleWidth / 2)
                        .clamp(minCart, maxCart);

                return Row(
                  children: [
                    Expanded(
                      child: _buildCatalogWithScanFocus(
                        context: context,
                        state: state,
                        theme: theme,
                        categories: categories,
                        isDark: isDark,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragUpdate: (details) {
                          final nextWidth = (cartWidth - details.delta.dx)
                              .clamp(minCart, maxCart);
                          final nextFraction =
                              ((nextWidth + handleWidth / 2) /
                                      constraints.maxWidth)
                                  .clamp(0.28, 0.55);
                          if ((nextFraction - _cartWidthFraction).abs() <
                              0.0005) {
                            return;
                          }
                          setState(() => _cartWidthFraction = nextFraction);
                        },
                        onHorizontalDragEnd: (_) {
                          PosUiPrefs.instance
                              .setCartWidthFraction(_cartWidthFraction);
                        },
                        child: SizedBox(
                          width: handleWidth,
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: cartWidth,
                      child: PosCartPanel(
                        state: state,
                        metaExpanded: _metaExpanded,
                        onMetaExpandedChanged: _setMetaExpanded,
                        customerController: _customerController,
                        notesController: _notesController,
                        discountController: _discountController,
                        customerFocus: _customerFocus,
                        notesFocus: _notesFocus,
                        discountFocus: _discountFocus,
                        onFieldEditingComplete: _ensureScanFocus,
                        onAddCustomer: _addCustomer,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        if (state.message != null)
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: AppToastBanner(
              message: state.message!,
              tone: AppToastBanner.toneForMessage(state.message!),
              compact: false,
              onDismiss: () =>
                  context.read<PosBloc>().add(const PosDismissMessage()),
            ),
          ),
      ],
    );
  }

  Widget _buildCatalogWithScanFocus({
    required BuildContext context,
    required PosReady state,
    required ThemeData theme,
    required List<String> categories,
    required bool isDark,
  }) {
    return Focus(
      focusNode: _scanFocus,
      autofocus: true,
      onKeyEvent: _onScanKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onBackgroundTap,
        child: _buildCatalogPane(
          context: context,
          state: state,
          theme: theme,
          categories: categories,
          isDark: isDark,
        ),
      ),
    );
  }

  Widget _buildCatalogPane({
    required BuildContext context,
    required PosReady state,
    required ThemeData theme,
    required List<String> categories,
    required bool isDark,
  }) {
    final hasQuery = state.query.trim().isNotEmpty;
    final categoryFiltered = state.selectedCategory != 'All';
    final stockFiltered = state.stockFilter != PosStockFilter.all;
    final toolsActive = hasQuery || categoryFiltered || stockFiltered;

    final cartQuantities = <int, int>{};
    for (final line in state.lines) {
      cartQuantities.update(
        line.product.id,
        (quantity) => quantity + line.quantity,
        ifAbsent: () => line.quantity,
      );
    }

    final grid = Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFDFE6F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFC8D2E0),
        ),
        boxShadow: AppShadows.sm(theme.brightness),
      ),
      clipBehavior: Clip.hardEdge,
      child: PosProductGrid(
        products: state.visibleProducts,
        cartQuantities: cartQuantities,
        layout: _productLayout,
      ),
    );

    if (_toolsOpen) {
      return Column(
        children: [
          _PosToolsBar(
            state: state,
            categories: categories,
            isDark: isDark,
            theme: theme,
            hasQuery: hasQuery,
            categoryFiltered: categoryFiltered,
            searchController: _searchController,
            searchFocus: _searchFocus,
            onCollapse: () => _setToolsOpen(false),
            onSearchChanged: _onSearchChanged,
            onSearchSubmitted: () => _ensureScanFocus(),
            onClearSearch: () {
              _searchController.clear();
              _onSearchChanged('');
              _ensureScanFocus();
            },
            onCategorySelected: (category) {
              context.read<PosBloc>().add(PosCategorySelected(category));
              _ensureScanFocus();
            },
            onStockFilterSelected: (filter) {
              context.read<PosBloc>().add(PosStockFilterSelected(filter));
              _ensureScanFocus();
            },
            productLayout: _productLayout,
            onProductLayoutChanged: (layout) {
              setState(() => _productLayout = layout);
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(child: grid),
        ],
      );
    }

    return Column(
      children: [
        _PosCatalogActionsBar(
          isDark: isDark,
          theme: theme,
          toolsActive: toolsActive,
          productLayout: _productLayout,
          onOpenSearch: () => _setToolsOpen(true),
          onProductLayoutChanged: (layout) {
            setState(() => _productLayout = layout);
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(child: grid),
      ],
    );
  }
}

class _PosCatalogActionsBar extends StatelessWidget {
  const _PosCatalogActionsBar({
    required this.isDark,
    required this.theme,
    required this.toolsActive,
    required this.productLayout,
    required this.onOpenSearch,
    required this.onProductLayoutChanged,
  });

  final bool isDark;
  final ThemeData theme;
  final bool toolsActive;
  final PosProductLayout productLayout;
  final VoidCallback onOpenSearch;
  final ValueChanged<PosProductLayout> onProductLayoutChanged;

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.darkCard : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final iconColor = toolsActive
        ? AppColors.accent
        : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onOpenSearch,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Badge(
                isLabelVisible: toolsActive,
                smallSize: 8,
                child: IconButton(
                  tooltip: 'Search products',
                  onPressed: onOpenSearch,
                  icon: Icon(Symbols.search, size: 22, color: iconColor),
                ),
              ),
              Expanded(
                child: Text(
                  'Search products…',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              _ProductLayoutButton(
                layout: productLayout,
                onChanged: onProductLayoutChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductLayoutButton extends StatelessWidget {
  const _ProductLayoutButton({required this.layout, required this.onChanged});

  final PosProductLayout layout;
  final ValueChanged<PosProductLayout> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isList = layout == PosProductLayout.list;
    return IconButton(
      tooltip: isList ? 'Switch to grid' : 'Switch to list',
      onPressed: () =>
          onChanged(isList ? PosProductLayout.grid : PosProductLayout.list),
      icon: Icon(
        isList ? Symbols.view_agenda : Symbols.grid_view,
        size: 20,
        color: isList ? AppColors.accent : theme.iconTheme.color,
      ),
    );
  }
}

class _PosToolsBar extends StatelessWidget {
  const _PosToolsBar({
    required this.state,
    required this.categories,
    required this.isDark,
    required this.theme,
    required this.hasQuery,
    required this.categoryFiltered,
    required this.searchController,
    required this.searchFocus,
    required this.onCollapse,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onCategorySelected,
    required this.onStockFilterSelected,
    required this.productLayout,
    required this.onProductLayoutChanged,
  });

  final PosReady state;
  final List<String> categories;
  final bool isDark;
  final ThemeData theme;
  final bool hasQuery;
  final bool categoryFiltered;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onCollapse;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchSubmitted;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<PosStockFilter> onStockFilterSelected;
  final PosProductLayout productLayout;
  final ValueChanged<PosProductLayout> onProductLayoutChanged;

  static const _stockFilters = <(PosStockFilter, String)>[
    (PosStockFilter.all, 'All'),
    (PosStockFilter.expired, 'Expired'),
    (PosStockFilter.lowStock, 'Low stock'),
  ];

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.darkCard : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: AppShadows.sm(theme.brightness),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocus,
                    onChanged: onSearchChanged,
                    onSubmitted: (_) => onSearchSubmitted(),
                    textInputAction: TextInputAction.search,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search name or SKU…',
                      prefixIcon: const Icon(Symbols.search, size: 18),
                      suffixIcon: hasQuery
                          ? IconButton(
                              tooltip: 'Clear',
                              icon: const Icon(Symbols.close, size: 16),
                              onPressed: onClearSearch,
                            )
                          : null,
                      isDense: true,
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceMuted
                          : const Color(0xFFF3F6FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.accent.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _CategoryDropdown(
                categories: categories,
                selected: state.selectedCategory,
                compact: true,
                emphasized: categoryFiltered,
                onSelected: onCategorySelected,
              ),
              const SizedBox(width: 6),
              _ProductLayoutButton(
                layout: productLayout,
                onChanged: onProductLayoutChanged,
              ),
              const SizedBox(width: 6),
              AppIconButton(
                icon: Symbols.keyboard_arrow_up,
                tooltip: 'Hide tools',
                selected: true,
                onPressed: onCollapse,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _stockFilters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final (filter, label) = _stockFilters[index];
                final selected = filter == state.stockFilter;
                final accent = switch (filter) {
                  PosStockFilter.expired => AppColors.danger,
                  PosStockFilter.lowStock => AppColors.warning,
                  PosStockFilter.all => AppColors.accent,
                };
                return _SlimFilterChip(
                  label: label,
                  selected: selected,
                  isDark: isDark,
                  accent: accent,
                  onTap: () => onStockFilterSelected(filter),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = category == state.selectedCategory;
                return _SlimFilterChip(
                  label: category,
                  selected: selected,
                  isDark: isDark,
                  accent: AppColors.accent,
                  onTap: () => onCategorySelected(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.compact = false,
    this.emphasized = false,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;
  final bool compact;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopupMenuButton<String>(
      tooltip: 'Category',
      onSelected: onSelected,
      offset: const Offset(0, 36),
      itemBuilder: (context) => [
        for (final category in categories)
          PopupMenuItem(
            value: category,
            child: Text(
              category,
              style: TextStyle(
                fontWeight: category == selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: category == selected ? AppColors.accent : null,
              ),
            ),
          ),
      ],
      child: Container(
        height: compact ? 32 : 36,
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10),
        decoration: BoxDecoration(
          color: emphasized
              ? AppColors.accent.withValues(alpha: 0.14)
              : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF3F6FA)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: emphasized ? 0.45 : 0.28),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: compact ? 88 : 110),
              child: Text(
                selected,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  fontSize: compact ? 12.5 : null,
                ),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Symbols.expand_more,
              size: compact ? 16 : 18,
              color: AppColors.accent.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlimFilterChip extends StatelessWidget {
  const _SlimFilterChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.16)
                : (isDark
                      ? AppColors.darkSurfaceMuted
                      : const Color(0xFFF3F6FA)),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.45)
                  : (isDark ? AppColors.darkBorder : AppColors.border),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? accent
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

String _discountFieldLabel(double value, CartDiscountMode mode) {
  if (value <= 0) return '';
  return switch (mode) {
    CartDiscountMode.percent => _discountPercentLabel(value),
    CartDiscountMode.fixed => _discountFixedLabel(value),
  };
}

String _discountPercentLabel(double percent) {
  if (percent == percent.roundToDouble()) {
    return percent.toInt().toString();
  }
  return percent.toStringAsFixed(1);
}

String _discountFixedLabel(double amount) {
  if (amount == amount.roundToDouble()) {
    return amount.toInt().toString();
  }
  return amount.toStringAsFixed(2);
}
