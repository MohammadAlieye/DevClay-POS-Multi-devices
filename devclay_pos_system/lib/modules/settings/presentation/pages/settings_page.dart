import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/developer_contact.dart';
import '../../../../core/auth/permissions.dart';
import '../../../../core/di/injection.dart';
import '../../../../services/hardware/device_status.dart';
import '../../../../services/hardware/hardware_service.dart';
import '../../../../services/media/product_image_store.dart';
import '../../../../services/feedback/app_sound_prefs.dart';
import '../../../../services/feedback/app_sound_service.dart';
import '../../../auth/presentation/widgets/sign_out_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../license/presentation/widgets/license_status_card.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../themes/app_theme_presets.dart';
import '../../../../themes/theme_cubit.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/settings_entities.dart';
import '../bloc/settings_bloc.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(const SettingsStarted()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          curr is SettingsLoaded && curr.message != null,
      listener: (context, state) {
        if (state is SettingsLoaded && state.message != null) {
          if (state.message ==
                  'Data backed up and cleared. Please sign in again.' ||
              state.message == 'Backup imported. Please sign in again.') {
            context.read<AuthBloc>().add(const AuthLogoutRequested());
            return;
          }
          AppToast.show(context, state.message!);
          if (state.message == 'Settings saved') {
            context.read<AuthBloc>().add(const AuthSessionRefreshed());
          }
          context.read<SettingsBloc>().add(const SettingsMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          SettingsInitial() ||
          SettingsLoading() => const Center(child: CircularProgressIndicator()),
          SettingsError(:final message) => EmptyState(
            title: 'Settings unavailable',
            message: message,
            icon: Symbols.settings,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<SettingsBloc>().add(const SettingsStarted()),
            ),
          ),
          SettingsLoaded() => _SettingsLoadedView(state: state),
        };
      },
    );
  }
}

class _SettingsLoadedView extends StatefulWidget {
  const _SettingsLoadedView({required this.state});

  final SettingsLoaded state;

  @override
  State<_SettingsLoadedView> createState() => _SettingsLoadedViewState();
}

class _SettingsLoadedViewState extends State<_SettingsLoadedView> {
  late final TextEditingController _businessName;
  late final TextEditingController _businessCity;
  late final TextEditingController _businessPhone;
  late final TextEditingController _businessEmail;
  late final TextEditingController _businessAddress;
  late final TextEditingController _taxNumber;
  late final TextEditingController _defaultTaxRate;
  late final TextEditingController _receiptFooter;
  late final TextEditingController _receiptTitle;
  late final TextEditingController _receiptTerms;
  late final TextEditingController _receiptCounterName;
  late final TextEditingController _receiptSystemName;
  late final TextEditingController _printerName;
  late bool _taxEnabled;
  late bool _defaultTaxInclusive;
  late bool _showBusinessInfoOnReceipt;
  late bool _fbrInvoiceEnabled;
  late bool _autoPrintReceipt;
  late int _paperWidthMm;
  late int _receiptContentWidthMm;
  late String _receiptPrintAlign;
  String? _receiptLogoPath;
  late List<String> _productUnits;
  late List<String> _productCategories;
  final _newUnit = TextEditingController();
  final _newCategory = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = widget.state.settings;
    _businessName = TextEditingController(text: settings.businessName);
    _businessCity = TextEditingController(text: settings.businessCity);
    _businessPhone = TextEditingController(text: settings.businessPhone);
    _businessEmail = TextEditingController(text: settings.businessEmail);
    _businessAddress = TextEditingController(text: settings.businessAddress);
    _taxNumber = TextEditingController(text: settings.taxNumber);
    _defaultTaxRate = TextEditingController(
      text: settings.defaultTaxRate.toStringAsFixed(0),
    );
    _receiptFooter = TextEditingController(text: settings.receiptFooter);
    _receiptTitle = TextEditingController(text: settings.receiptTitle);
    _receiptTerms = TextEditingController(text: settings.receiptTerms);
    _receiptCounterName = TextEditingController(
      text: settings.receiptCounterName,
    );
    _receiptSystemName = TextEditingController(
      text: settings.receiptSystemName,
    );
    _printerName = TextEditingController(text: settings.printerName);
    _defaultTaxInclusive = settings.defaultTaxInclusive;
    _taxEnabled = settings.taxEnabled;
    _showBusinessInfoOnReceipt = settings.showBusinessInfoOnReceipt;
    _fbrInvoiceEnabled = settings.fbrInvoiceEnabled;
    _autoPrintReceipt = settings.autoPrintReceipt;
    _paperWidthMm = settings.paperWidthMm;
    _receiptContentWidthMm = settings.receiptContentWidthMm;
    _receiptPrintAlign = settings.receiptPrintAlign;
    _receiptLogoPath = settings.receiptLogoPath;
    _productUnits = List<String>.from(settings.productUnits);
    _productCategories = List<String>.from(settings.productCategories);
  }

  @override
  void didUpdateWidget(covariant _SettingsLoadedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.settings != widget.state.settings) {
      final settings = widget.state.settings;
      _businessName.text = settings.businessName;
      _businessCity.text = settings.businessCity;
      _businessPhone.text = settings.businessPhone;
      _businessEmail.text = settings.businessEmail;
      _businessAddress.text = settings.businessAddress;
      _taxNumber.text = settings.taxNumber;
      _defaultTaxRate.text = settings.defaultTaxRate.toStringAsFixed(0);
      _receiptFooter.text = settings.receiptFooter;
      _receiptTitle.text = settings.receiptTitle;
      _receiptTerms.text = settings.receiptTerms;
      _receiptCounterName.text = settings.receiptCounterName;
      _receiptSystemName.text = settings.receiptSystemName;
      _printerName.text = settings.printerName;
      setState(() {
        _defaultTaxInclusive = settings.defaultTaxInclusive;
        _taxEnabled = settings.taxEnabled;
        _showBusinessInfoOnReceipt = settings.showBusinessInfoOnReceipt;
        _fbrInvoiceEnabled = settings.fbrInvoiceEnabled;
        _autoPrintReceipt = settings.autoPrintReceipt;
        _paperWidthMm = settings.paperWidthMm;
        _receiptContentWidthMm = settings.receiptContentWidthMm;
        _receiptPrintAlign = settings.receiptPrintAlign;
        _receiptLogoPath = settings.receiptLogoPath;
        _productUnits = List<String>.from(settings.productUnits);
        _productCategories = List<String>.from(settings.productCategories);
      });
    }
  }

  @override
  void dispose() {
    _businessName.dispose();
    _businessCity.dispose();
    _businessPhone.dispose();
    _businessEmail.dispose();
    _businessAddress.dispose();
    _taxNumber.dispose();
    _defaultTaxRate.dispose();
    _receiptFooter.dispose();
    _receiptTitle.dispose();
    _receiptTerms.dispose();
    _receiptCounterName.dispose();
    _receiptSystemName.dispose();
    _printerName.dispose();
    _newUnit.dispose();
    _newCategory.dispose();
    super.dispose();
  }

  AppSettingsDraft _buildDraft() {
    return AppSettingsDraft(
      businessName: _businessName.text,
      businessCity: _businessCity.text,
      businessPhone: _businessPhone.text,
      businessEmail: _businessEmail.text,
      businessAddress: _businessAddress.text,
      taxNumber: _taxNumber.text,
      defaultTaxRate: double.tryParse(_defaultTaxRate.text.trim()) ?? 0,
      defaultTaxInclusive: _defaultTaxInclusive,
      taxEnabled: _taxEnabled,
      receiptFooter: _receiptFooter.text,
      showBusinessInfoOnReceipt: _showBusinessInfoOnReceipt,
      receiptTitle: _receiptTitle.text,
      receiptLogoPath: _receiptLogoPath,
      receiptTerms: _receiptTerms.text,
      receiptCounterName: _receiptCounterName.text,
      receiptSystemName: _receiptSystemName.text,
      fbrInvoiceEnabled: _fbrInvoiceEnabled,
      printerName: _printerName.text,
      autoPrintReceipt: _autoPrintReceipt,
      paperWidthMm: _paperWidthMm,
      receiptContentWidthMm: _receiptContentWidthMm,
      receiptPrintAlign: _receiptPrintAlign,
      productUnits: List<String>.from(_productUnits),
      productCategories: List<String>.from(_productCategories),
      themeMode: context.read<ThemeCubit>().state.mode == ThemeMode.dark
          ? 'dark'
          : context.read<ThemeCubit>().state.mode == ThemeMode.system
          ? 'system'
          : 'light',
      accentPreset: context.read<ThemeCubit>().state.accent.id,
      primaryPreset: context.read<ThemeCubit>().state.primary.id,
    );
  }

  void _addUnit() {
    final value = _newUnit.text.trim();
    if (value.isEmpty) return;
    if (value.length > FieldLimits.unit) {
      AppToast.show(context, 'Unit name is too long.');
      return;
    }
    if (DefaultProductUnits.isBase(value)) {
      AppToast.show(context, 'That base unit is already locked in the list.');
      return;
    }
    final exists = _productUnits.any(
      (u) => u.toLowerCase() == value.toLowerCase(),
    );
    if (exists) {
      AppToast.show(context, 'Unit already exists.');
      return;
    }
    setState(() {
      _productUnits = DefaultProductUnits.mergeWithBase([
        ..._productUnits,
        value,
      ]);
      _newUnit.clear();
    });
  }

  void _removeUnit(String unit) {
    if (DefaultProductUnits.isBase(unit)) {
      AppToast.show(
        context,
        'Base units cannot be removed. Stock math depends on them.',
      );
      return;
    }
    setState(() {
      _productUnits = DefaultProductUnits.mergeWithBase(
        _productUnits.where((u) => u != unit),
      );
    });
  }

  void _resetUnits() {
    setState(() {
      _productUnits = List<String>.from(DefaultProductUnits.all);
    });
  }

  void _addCategory() {
    final value = _newCategory.text.trim();
    if (value.isEmpty) return;
    if (value.length > FieldLimits.category) {
      AppToast.show(context, 'Category name is too long.');
      return;
    }
    final exists = _productCategories.any(
      (category) => category.toLowerCase() == value.toLowerCase(),
    );
    if (exists) {
      AppToast.show(context, 'Category already exists.');
      return;
    }
    setState(() {
      _productCategories = [..._productCategories, value];
      _newCategory.clear();
    });
  }

  void _removeCategory(String category) {
    setState(() {
      _productCategories =
          _productCategories.where((c) => c != category).toList();
    });
  }

  void _resetCategories() {
    setState(() {
      _productCategories = List<String>.from(DefaultProductCategories.all);
    });
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) return;
    try {
      final saved = await sl<ProductImageStore>().saveFromPath(path);
      final previous = _receiptLogoPath;
      setState(() => _receiptLogoPath = saved);
      if (previous != null && previous != saved) {
        await sl<ProductImageStore>().deleteIfExists(previous);
      }
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, userFacingError(error));
    }
  }

  Future<void> _removeLogo() async {
    final previous = _receiptLogoPath;
    setState(() => _receiptLogoPath = null);
    await sl<ProductImageStore>().deleteIfExists(previous);
  }

  void _save() {
    if (_productUnits.isEmpty) {
      AppToast.show(context, 'Add at least one product unit before saving.');
      return;
    }
    context.read<SettingsBloc>().add(SettingsSaved(_buildDraft()));
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.state.settings;
    final dateFormat = DateFormat('d MMM yyyy · HH:mm');
    final isOwner = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.sessionOrNull?.user.role == AppRoles.owner,
    );
    final theme = Theme.of(context);

    const tabs = <({SettingsTab tab, String label, IconData icon})>[
      (tab: SettingsTab.business, label: 'Business', icon: Symbols.storefront),
      (
        tab: SettingsTab.receiptTax,
        label: 'Receipt & tax',
        icon: Symbols.receipt_long,
      ),
      (tab: SettingsTab.devices, label: 'Devices', icon: Symbols.devices),
      (tab: SettingsTab.units, label: 'Units & categories', icon: Symbols.straighten),
      (tab: SettingsTab.theme, label: 'Theme', icon: Symbols.palette),
      (tab: SettingsTab.backup, label: 'Backup', icon: Symbols.backup),
      (tab: SettingsTab.license, label: 'License', icon: Symbols.verified),
      (tab: SettingsTab.about, label: 'About', icon: Symbols.info),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 220,
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Text(
                      'Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final item in tabs)
                          _SettingsNavTile(
                            label: item.label,
                            icon: item.icon,
                            selected: widget.state.tab == item.tab,
                            onTap: () => context.read<SettingsBloc>().add(
                              SettingsTabChanged(item.tab),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: AppButton(
                      label: 'Sign out',
                      icon: Symbols.logout,
                      variant: AppButtonVariant.secondary,
                      expanded: true,
                      onPressed: () => requestSignOut(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SingleChildScrollView(
                      child: switch (widget.state.tab) {
                        SettingsTab.business => _BusinessSection(
                          businessName: _businessName,
                          businessCity: _businessCity,
                          businessPhone: _businessPhone,
                          businessEmail: _businessEmail,
                          businessAddress: _businessAddress,
                          taxNumber: _taxNumber,
                        ),
                        SettingsTab.receiptTax => _ReceiptTaxSection(
                          taxEnabled: _taxEnabled,
                          defaultTaxRate: _defaultTaxRate,
                          defaultTaxInclusive: _defaultTaxInclusive,
                          receiptTitle: _receiptTitle,
                          receiptFooter: _receiptFooter,
                          receiptTerms: _receiptTerms,
                          receiptCounterName: _receiptCounterName,
                          receiptSystemName: _receiptSystemName,
                          receiptLogoPath: _receiptLogoPath,
                          showBusinessInfoOnReceipt: _showBusinessInfoOnReceipt,
                          fbrInvoiceEnabled: _fbrInvoiceEnabled,
                          onTaxEnabledChanged: (value) =>
                              setState(() => _taxEnabled = value),
                          onDefaultTaxInclusiveChanged: (value) =>
                              setState(() => _defaultTaxInclusive = value),
                          onShowBusinessInfoChanged: (value) => setState(
                            () => _showBusinessInfoOnReceipt = value,
                          ),
                          onFbrInvoiceEnabledChanged: (value) =>
                              setState(() => _fbrInvoiceEnabled = value),
                          onPickLogo: _pickLogo,
                          onRemoveLogo: _removeLogo,
                        ),
                        SettingsTab.devices => _DevicesSection(
                          printerName: _printerName,
                          autoPrintReceipt: _autoPrintReceipt,
                          paperWidthMm: _paperWidthMm,
                          receiptContentWidthMm: _receiptContentWidthMm,
                          receiptPrintAlign: _receiptPrintAlign,
                          onAutoPrintChanged: (value) =>
                              setState(() => _autoPrintReceipt = value),
                          onPaperWidthChanged: (value) {
                            setState(() {
                              _paperWidthMm = value;
                              // Keep content width inside the new paper size.
                              if (_receiptContentWidthMm > value - 2) {
                                _receiptContentWidthMm = value >= 80 ? 72 : 48;
                              } else if (value >= 80 &&
                                  _receiptContentWidthMm < 60) {
                                _receiptContentWidthMm = 72;
                              } else if (value < 80 &&
                                  _receiptContentWidthMm > 52) {
                                _receiptContentWidthMm = 48;
                              }
                            });
                          },
                          onContentWidthChanged: (value) =>
                              setState(() => _receiptContentWidthMm = value),
                          onPrintAlignChanged: (value) =>
                              setState(() => _receiptPrintAlign = value),
                        ),
                        SettingsTab.units => _UnitsSection(
                          units: _productUnits,
                          categories: _productCategories,
                          newUnitController: _newUnit,
                          newCategoryController: _newCategory,
                          onAddUnit: _addUnit,
                          onRemoveUnit: _removeUnit,
                          onResetUnits: _resetUnits,
                          onAddCategory: _addCategory,
                          onRemoveCategory: _removeCategory,
                          onResetCategories: _resetCategories,
                        ),
                        SettingsTab.theme => const _ThemeSection(),
                        SettingsTab.backup => _BackupSection(
                          lastBackupAt: settings.lastBackupAt,
                          lastBackupPath: settings.lastBackupPath,
                          dateFormat: dateFormat,
                          showClearDatabase: isOwner,
                          onBackup: () => context.read<SettingsBloc>().add(
                            const SettingsBackupRequested(),
                          ),
                          onImport: () => context.read<SettingsBloc>().add(
                            const SettingsImportBackupRequested(),
                          ),
                          onClearDatabase: () => context
                              .read<SettingsBloc>()
                              .add(const SettingsClearDatabaseRequested()),
                        ),
                        SettingsTab.license => const LicenseStatusCard(),
                        SettingsTab.about => const _AboutSection(),
                      },
                    ),
                  ),
                ),
                if (widget.state.tab != SettingsTab.backup &&
                    widget.state.tab != SettingsTab.theme &&
                    widget.state.tab != SettingsTab.license &&
                    widget.state.tab != SettingsTab.about) ...[
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      label: 'Save changes',
                      icon: Symbols.save,
                      onPressed: _save,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: Material(
        color: selected
            ? AppColors.accent.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? AppColors.accent
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selected
                          ? AppColors.accent
                          : theme.colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BusinessSection extends StatelessWidget {
  const _BusinessSection({
    required this.businessName,
    required this.businessCity,
    required this.businessPhone,
    required this.businessEmail,
    required this.businessAddress,
    required this.taxNumber,
  });

  final TextEditingController businessName;
  final TextEditingController businessCity;
  final TextEditingController businessPhone;
  final TextEditingController businessEmail;
  final TextEditingController businessAddress;
  final TextEditingController taxNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Store profile',
          subtitle: 'Name shown in the top bar, receipts, and reports',
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: businessName,
          label: 'Store name',
          hintText: 'e.g. Ali General Store',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: businessCity,
          label: 'City',
          hintText: 'Lahore',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: businessPhone,
          label: 'Phone',
          hintText: '0300 1234567',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: businessEmail,
          label: 'Email',
          hintText: 'hello@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: businessAddress,
          label: 'Address',
          hintText: 'Street, area',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: taxNumber,
          label: 'NTN / tax number',
          hintText: 'Optional for receipts',
        ),
      ],
    );
  }
}

class _ReceiptTaxSection extends StatelessWidget {
  const _ReceiptTaxSection({
    required this.taxEnabled,
    required this.defaultTaxRate,
    required this.defaultTaxInclusive,
    required this.receiptTitle,
    required this.receiptFooter,
    required this.receiptTerms,
    required this.receiptCounterName,
    required this.receiptSystemName,
    required this.receiptLogoPath,
    required this.showBusinessInfoOnReceipt,
    required this.fbrInvoiceEnabled,
    required this.onTaxEnabledChanged,
    required this.onDefaultTaxInclusiveChanged,
    required this.onShowBusinessInfoChanged,
    required this.onFbrInvoiceEnabledChanged,
    required this.onPickLogo,
    required this.onRemoveLogo,
  });

  final bool taxEnabled;
  final TextEditingController defaultTaxRate;
  final TextEditingController receiptTitle;
  final TextEditingController receiptFooter;
  final TextEditingController receiptTerms;
  final TextEditingController receiptCounterName;
  final TextEditingController receiptSystemName;
  final String? receiptLogoPath;
  final bool defaultTaxInclusive;
  final bool showBusinessInfoOnReceipt;
  final bool fbrInvoiceEnabled;
  final ValueChanged<bool> onTaxEnabledChanged;
  final ValueChanged<bool> onDefaultTaxInclusiveChanged;
  final ValueChanged<bool> onShowBusinessInfoChanged;
  final ValueChanged<bool> onFbrInvoiceEnabledChanged;
  final VoidCallback onPickLogo;
  final VoidCallback onRemoveLogo;

  @override
  Widget build(BuildContext context) {
    // Logo UI is temporarily disabled.
    // final hasLogo =
    //     receiptLogoPath != null &&
    //     receiptLogoPath!.isNotEmpty &&
    //     File(receiptLogoPath!).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Tax system',
          subtitle:
              'Turn tax on for the whole store. Defaults apply to new products; '
              'each product can still override the rate.',
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable tax'),
          subtitle: Text(
            taxEnabled
                ? 'Tax shows on products, POS cart, and receipts'
                : 'Tax hidden on products, POS cart, and receipts',
          ),
          value: taxEnabled,
          onChanged: onTaxEnabledChanged,
        ),
        if (taxEnabled) ...[
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
            title: 'Default tax',
            subtitle: 'Used when creating a new product (product can override)',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: defaultTaxRate,
            label: 'Default tax rate (%)',
            hintText: '17',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tax-inclusive pricing'),
            subtitle: const Text('Default: selling price already includes tax'),
            value: defaultTaxInclusive,
            onChanged: onDefaultTaxInclusiveChanged,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Receipt template',
          subtitle: 'Company header and layout used on POS print',
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show company details on receipts'),
          subtitle: const Text('Name, address, phone, and NTN'),
          value: showBusinessInfoOnReceipt,
          onChanged: onShowBusinessInfoChanged,
        ),
        // Logo upload temporarily disabled — keep field in draft for later.
        // const SizedBox(height: AppSpacing.sm),
        // AppCard(
        //   padding: const EdgeInsets.all(AppSpacing.md),
        //   child: Row(
        //     children: [
        //       ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: hasLogo
        //             ? Image.file(
        //                 File(receiptLogoPath!),
        //                 width: 64,
        //                 height: 64,
        //                 fit: BoxFit.cover,
        //               )
        //             : Container(
        //                 width: 64,
        //                 height: 64,
        //                 color: AppColors.accent.withValues(alpha: 0.08),
        //                 child: Icon(Symbols.image, color: AppColors.accent),
        //               ),
        //       ),
        //       const SizedBox(width: AppSpacing.md),
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               'Company logo',
        //               style: Theme.of(context).textTheme.titleSmall,
        //             ),
        //             Text(
        //               hasLogo
        //                   ? 'Shown at the top of printed receipts'
        //                   : 'Optional — add your store logo',
        //               style: Theme.of(context).textTheme.bodySmall,
        //             ),
        //             const SizedBox(height: AppSpacing.sm),
        //             Wrap(
        //               spacing: AppSpacing.sm,
        //               children: [
        //                 AppButton(
        //                   label: hasLogo ? 'Change logo' : 'Upload logo',
        //                   icon: Symbols.upload,
        //                   variant: AppButtonVariant.secondary,
        //                   onPressed: onPickLogo,
        //                 ),
        //                 if (hasLogo)
        //                   AppButton(
        //                     label: 'Remove',
        //                     icon: Symbols.delete,
        //                     variant: AppButtonVariant.ghost,
        //                     onPressed: onRemoveLogo,
        //                   ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: receiptTitle,
          label: 'Receipt title',
          hintText: 'Sale Receipt',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: receiptCounterName,
          label: 'Counter name',
          hintText: 'Counter 1',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: receiptSystemName,
          label: 'System / POS name',
          hintText: 'POS-01',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: receiptFooter,
          label: 'Thank-you / footer message',
          hintText: 'Thank you for shopping with us!',
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'FBR invoice',
          subtitle: 'Enable when FBR POS integration is ready',
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable FBR invoice block'),
          subtitle: const Text(
            'Shows FBR POS fee and verification text. Keep off until FBR is connected.',
          ),
          value: fbrInvoiceEnabled,
          onChanged: onFbrInvoiceEnabledChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Terms and conditions',
          subtitle: 'Printed near the bottom of every receipt',
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: receiptTerms,
          minLines: 5,
          maxLines: 10,
          decoration: const InputDecoration(
            labelText: 'Terms and conditions',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
            hintText: 'One rule per line…',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Developer contact',
          subtitle: 'Always printed at the bottom — not editable',
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Software by ${DeveloperContact.developerName}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              const Text(DeveloperContact.phoneDisplay),
              const Text(DeveloperContact.email),
              const Text(DeveloperContact.location),
            ],
          ),
        ),
      ],
    );
  }
}

class _DevicesSection extends StatefulWidget {
  const _DevicesSection({
    required this.printerName,
    required this.autoPrintReceipt,
    required this.paperWidthMm,
    required this.receiptContentWidthMm,
    required this.receiptPrintAlign,
    required this.onAutoPrintChanged,
    required this.onPaperWidthChanged,
    required this.onContentWidthChanged,
    required this.onPrintAlignChanged,
  });

  final TextEditingController printerName;
  final bool autoPrintReceipt;
  final int paperWidthMm;
  final int receiptContentWidthMm;
  final String receiptPrintAlign;
  final ValueChanged<bool> onAutoPrintChanged;
  final ValueChanged<int> onPaperWidthChanged;
  final ValueChanged<int> onContentWidthChanged;
  final ValueChanged<String> onPrintAlignChanged;

  @override
  State<_DevicesSection> createState() => _DevicesSectionState();
}

class _DevicesSectionState extends State<_DevicesSection> {
  HardwareDevicesSnapshot? _snapshot;
  bool _loading = true;
  String? _scannerLastRead;
  DateTime? _cashDrawerLastOpenedAt;
  late final TextEditingController _scannerTest;

  @override
  void initState() {
    super.initState();
    _scannerTest = TextEditingController();
    widget.printerName.addListener(_onPreferredPrinterChanged);
    _refreshDevices();
  }

  @override
  void dispose() {
    widget.printerName.removeListener(_onPreferredPrinterChanged);
    _scannerTest.dispose();
    super.dispose();
  }

  void _onPreferredPrinterChanged() {
    if (!mounted || _snapshot == null) return;
    final preferred = widget.printerName.text;
    final next = HardwareDevicesSnapshot(
      printers: _snapshot!.printers,
      preferredPrinterName: preferred,
      error: _snapshot!.error,
    );
    setState(() {
      _snapshot = HardwareDevicesSnapshot(
        printers: next.printers,
        preferredPrinterName: preferred,
        cashDrawer: HardwareDevicesSnapshot.cashDrawerFor(
          printer: next.matchedPrinter,
          supportedOnPlatform: Platform.isWindows,
        ),
        error: next.error,
      );
    });
  }

  Future<void> _refreshDevices() async {
    setState(() => _loading = true);
    final snapshot = await sl<HardwareService>().getDevicesSnapshot(
      preferredPrinterName: widget.printerName.text,
    );
    if (!mounted) return;
    setState(() {
      _snapshot = snapshot;
      _loading = false;
    });
  }

  void _selectPrinter(DiscoveredPrinter printer) {
    widget.printerName.text = printer.name;
  }

  void _onScannerSubmitted(String value) {
    final code = value.trim();
    if (code.isEmpty) return;
    setState(() {
      _scannerLastRead = code;
      _scannerTest.clear();
    });
  }

  Future<void> _testPrint() async {
    final width = widget.paperWidthMm >= 80 ? 80 : 58;
    final content = widget.receiptContentWidthMm;
    final sample = [
      '*** TEST RECEIPT ***',
      'DevClay POS',
      'Paper: $width mm',
      'Content: $content mm',
      'Align: ${widget.receiptPrintAlign}',
      '------------------------------',
      'Item A                   100.00',
      'Item B                    50.00',
      '------------------------------',
      'TOTAL                    150.00',
      '',
      'Software by ${DeveloperContact.developerName}',
      DeveloperContact.phoneDisplay,
      DeveloperContact.email,
      '',
      DateTime.now().toIso8601String(),
    ].join('\n');

    try {
      await sl<HardwareService>().printReceipt(
        sample,
        printerName: widget.printerName.text.trim().isEmpty
            ? null
            : widget.printerName.text.trim(),
        paperWidthMm: width,
        contentWidthMm: content,
        align: widget.receiptPrintAlign,
        showDialogFallback: true,
      );
      if (!mounted) return;
      AppToast.show(context, 'Test receipt sent ($width mm)');
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, 'Test print failed: $error');
    }
  }

  Future<void> _testOpenCashDrawer() async {
    try {
      await sl<HardwareService>().openCashDrawer(
        printerName: widget.printerName.text.trim().isEmpty
            ? null
            : widget.printerName.text.trim(),
      );
      if (!mounted) return;
      setState(() => _cashDrawerLastOpenedAt = DateTime.now());
      AppToast.show(context, 'Cash drawer kick sent');
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, 'Cash drawer failed: $error');
    }
  }

  List<int> _contentWidthOptions(int paperWidthMm) {
    if (paperWidthMm >= 80) {
      return const [64, 68, 70, 72, 74, 76];
    }
    return const [42, 44, 46, 48, 50, 52];
  }

  int _resolvedContentWidth() {
    final options = _contentWidthOptions(widget.paperWidthMm);
    if (options.contains(widget.receiptContentWidthMm)) {
      return widget.receiptContentWidthMm;
    }
    return widget.paperWidthMm >= 80 ? 72 : 48;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = _snapshot;
    final matched = snapshot?.matchedPrinter;
    final preferred = widget.printerName.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Devices',
          subtitle:
              'See which printers Windows reports, and verify your scanner',
          trailing: AppButton(
            label: 'Refresh',
            icon: Symbols.refresh,
            variant: AppButtonVariant.secondary,
            onPressed: _loading ? null : _refreshDevices,
            isLoading: _loading,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _DeviceStatusSummary(
          loading: _loading,
          printerOnline: matched?.isAvailable == true,
          printerLabel:
              matched?.name ??
              (preferred.isEmpty ? 'No printer selected' : preferred),
          printerFound: matched != null,
          cashDrawer: snapshot?.cashDrawer,
          cashDrawerLastOpenedAt: _cashDrawerLastOpenedAt,
          scannerVerified: _scannerLastRead != null,
          scannerLastRead: _scannerLastRead,
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Printers',
          subtitle:
              'Installed printers from Windows. Select one to use for receipts.',
        ),
        const SizedBox(height: AppSpacing.md),
        if (_loading && snapshot == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (snapshot == null || snapshot.printers.isEmpty)
          AppCard(
            child: Text(
              snapshot?.error ??
                  'No printers found. Install a printer in Windows Settings, '
                      'then tap Refresh.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          ...snapshot.printers.map((printer) {
            final selected =
                matched?.url == printer.url ||
                (matched == null &&
                    preferred.isNotEmpty &&
                    printer.matchesPreferredName(preferred));
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PrinterDeviceTile(
                printer: printer,
                selected: selected,
                onSelect: () => _selectPrinter(printer),
              ),
            );
          }),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: widget.printerName,
          label: 'Selected printer name',
          hintText: 'Pick from the list or type the Windows printer name',
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<int>(
          initialValue: widget.paperWidthMm,
          decoration: const InputDecoration(
            labelText: 'Paper width',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 58, child: Text('58 mm (narrow)')),
            DropdownMenuItem(value: 80, child: Text('80 mm (standard)')),
          ],
          onChanged: (value) {
            if (value != null) widget.onPaperWidthChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<int>(
          key: ValueKey(
            'content-${widget.paperWidthMm}-${_resolvedContentWidth()}',
          ),
          initialValue: _resolvedContentWidth(),
          decoration: const InputDecoration(
            labelText: 'Print content width',
            helperText:
                'Use 68–72 mm if text looks cramped or values wrap on 80 mm paper',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final mm in _contentWidthOptions(widget.paperWidthMm))
              DropdownMenuItem(value: mm, child: Text('$mm mm')),
          ],
          onChanged: (value) {
            if (value != null) widget.onContentWidthChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: widget.receiptPrintAlign == 'left' ? 'left' : 'center',
          decoration: const InputDecoration(
            labelText: 'Print alignment',
            helperText: 'Match how your bill sits on the thermal roll',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'center', child: Text('Center')),
            DropdownMenuItem(value: 'left', child: Text('Left')),
          ],
          onChanged: (value) {
            if (value != null) widget.onPrintAlignChanged(value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto-print after checkout'),
          subtitle: const Text(
            'Send receipt to printer when a POS sale completes',
          ),
          value: widget.autoPrintReceipt,
          onChanged: widget.onAutoPrintChanged,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Test print (${widget.paperWidthMm >= 80 ? 80 : 58} mm)',
          icon: Symbols.print,
          variant: AppButtonVariant.secondary,
          onPressed: _loading ? null : _testPrint,
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Cash drawer',
          subtitle:
              'Connects to the receipt printer DK port. Status follows the selected printer.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot?.cashDrawer.detail ??
                    'Select a receipt printer to enable the cash drawer.',
                style: theme.textTheme.bodyMedium,
              ),
              if (_cashDrawerLastOpenedAt != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Last kick: ${DateFormat('h:mm:ss a').format(_cashDrawerLastOpenedAt!)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Test open cash drawer',
                icon: Symbols.point_of_sale,
                variant: AppButtonVariant.secondary,
                onPressed: _loading ? null : _testOpenCashDrawer,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(
          title: 'Barcode scanner',
          subtitle:
              'Most USB scanners act like a keyboard. Scan into the field below to confirm it works.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _scannerTest,
          label: 'Scanner test',
          hintText: 'Click here, then scan any barcode',
          onSubmitted: _onScannerSubmitted,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_scannerLastRead != null)
          AppCard(
            child: Row(
              children: [
                const Icon(
                  Symbols.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Scanner read: $_scannerLastRead',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            'Focus the field, scan a product barcode, and press Enter '
            '(many scanners send Enter automatically).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.info, size: 18, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Printer status comes from Windows. Raw thermal / Zebra '
                  'drivers are still being wired — receipts preview on screen '
                  'until that lands. On POS, scan a barcode anytime to add '
                  'items to the cart (it will not type into the search box).',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceStatusSummary extends StatelessWidget {
  const _DeviceStatusSummary({
    required this.loading,
    required this.printerOnline,
    required this.printerLabel,
    required this.printerFound,
    required this.cashDrawer,
    required this.cashDrawerLastOpenedAt,
    required this.scannerVerified,
    required this.scannerLastRead,
  });

  final bool loading;
  final bool printerOnline;
  final String printerLabel;
  final bool printerFound;
  final CashDrawerStatus? cashDrawer;
  final DateTime? cashDrawerLastOpenedAt;
  final bool scannerVerified;
  final String? scannerLastRead;

  @override
  Widget build(BuildContext context) {
    final drawer = cashDrawer;
    final drawerTone = loading || drawer == null
        ? _StatusTone.neutral
        : switch (drawer.state) {
            CashDrawerLinkState.ready => _StatusTone.success,
            CashDrawerLinkState.printerOffline => _StatusTone.warning,
            CashDrawerLinkState.noPrinter => _StatusTone.danger,
            CashDrawerLinkState.unsupported => _StatusTone.neutral,
          };
    final drawerDetail = cashDrawerLastOpenedAt != null
        ? 'Last kick: ${DateFormat('h:mm:ss a').format(cashDrawerLastOpenedAt!)}'
        : (drawer?.detail ?? 'Links through the receipt printer');

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 720;
        final chips = [
          _StatusChipCard(
            icon: Symbols.print,
            title: 'Printer',
            status: loading
                ? 'Checking…'
                : !printerFound
                ? 'Not found'
                : printerOnline
                ? 'Connected'
                : 'Offline',
            detail: printerLabel,
            tone: loading
                ? _StatusTone.neutral
                : !printerFound
                ? _StatusTone.danger
                : printerOnline
                ? _StatusTone.success
                : _StatusTone.warning,
          ),
          _StatusChipCard(
            icon: Symbols.point_of_sale,
            title: 'Cash drawer',
            status: loading ? 'Checking…' : (drawer?.label ?? 'Unknown'),
            detail: drawerDetail,
            tone: drawerTone,
          ),
          _StatusChipCard(
            icon: Symbols.barcode_scanner,
            title: 'Scanner',
            status: scannerVerified ? 'Verified' : 'Not tested',
            detail: scannerVerified
                ? 'Last: $scannerLastRead'
                : 'Use the test field below',
            tone: scannerVerified ? _StatusTone.success : _StatusTone.neutral,
          ),
        ];

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < chips.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: chips[i]),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < chips.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              chips[i],
            ],
          ],
        );
      },
    );
  }
}

enum _StatusTone { success, warning, danger, neutral }

class _StatusChipCard extends StatelessWidget {
  const _StatusChipCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.detail,
    required this.tone,
  });

  final IconData icon;
  final String title;
  final String status;
  final String detail;
  final _StatusTone tone;

  Color get _toneColor => switch (tone) {
    _StatusTone.success => AppColors.success,
    _StatusTone.warning => AppColors.warning,
    _StatusTone.danger => AppColors.danger,
    _StatusTone.neutral => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _toneColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _toneColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _toneColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterDeviceTile extends StatelessWidget {
  const _PrinterDeviceTile({
    required this.printer,
    required this.selected,
    required this.onSelect,
  });

  final DiscoveredPrinter printer;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final online = printer.isAvailable;
    final statusColor = online ? AppColors.success : AppColors.warning;

    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: 0.08)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Symbols.check_circle : Symbols.print,
                color: selected ? AppColors.accent : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      printer.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (printer.model != null && printer.model!.isNotEmpty)
                          printer.model!,
                        if (printer.isDefault) 'Default',
                        online ? 'Available' : 'Offline',
                      ].join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitsSection extends StatelessWidget {
  const _UnitsSection({
    required this.units,
    required this.categories,
    required this.newUnitController,
    required this.newCategoryController,
    required this.onAddUnit,
    required this.onRemoveUnit,
    required this.onResetUnits,
    required this.onAddCategory,
    required this.onRemoveCategory,
    required this.onResetCategories,
  });

  final List<String> units;
  final List<String> categories;
  final TextEditingController newUnitController;
  final TextEditingController newCategoryController;
  final VoidCallback onAddUnit;
  final ValueChanged<String> onRemoveUnit;
  final VoidCallback onResetUnits;
  final VoidCallback onAddCategory;
  final ValueChanged<String> onRemoveCategory;
  final VoidCallback onResetCategories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseUnits =
        units.where(DefaultProductUnits.isBase).toList(growable: false);
    final customUnits =
        units.where((u) => !DefaultProductUnits.isBase(u)).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Product units',
          subtitle:
              'Base units are locked for stock math. Add custom units for your shop.',
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'How to use\n'
            '• pcs — count items (soap, bottles).\n'
            '• kg / g — weight; stock is stored in grams.\n'
            '• L / ml — liquids; stock is stored in milliliters.\n'
            '• m / cm / mm / half m — length; stock is stored in millimeters.\n'
            '• Custom (half, plate, box…) — piece-style labels only; they do not change stock math.\n'
            'Tip: removing a custom unit only hides the chip. Products already saved keep their old unit text.',
            style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text('Base units', style: theme.textTheme.titleSmall),
            const Spacer(),
            Text(
              'Locked',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ScrollableChipWrap(
          maxLines: 3,
          children: baseUnits
              .map(
                (unit) => Chip(
                  avatar: Icon(
                    Symbols.lock,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  label: Text(unit),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Text('Custom units', style: theme.textTheme.titleSmall),
            const Spacer(),
            TextButton(
              onPressed: onResetUnits,
              child: const Text('Reset defaults'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: newUnitController,
                maxLength: FieldLimits.unit,
                decoration: const InputDecoration(
                  labelText: 'New custom unit',
                  hintText: 'e.g. FULL, PLATE, BOX',
                  counterText: '',
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAddUnit(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(label: 'Add', icon: Symbols.add, onPressed: onAddUnit),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (customUnits.isEmpty)
          Text(
            'No custom units yet. Add shop labels like plate, karahi, or pack.',
            style: theme.textTheme.bodySmall,
          )
        else
          ScrollableChipWrap(
            maxLines: 5,
            children: customUnits
                .map(
                  (unit) => InputChip(
                    label: Text(unit),
                    onDeleted: () => onRemoveUnit(unit),
                    deleteIcon: const Icon(Symbols.close, size: 16),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(
          title: 'Product categories',
          subtitle:
              'Manage category chips used when adding products and filtering POS.',
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'How to use\n'
            '• Keep short, consistent names (Grocery, Dairy, Snacks).\n'
            '• Avoid near-duplicates like “Snack” and “Snacks” — POS will treat them as different.\n'
            '• Removing a category here only removes the chip. Products already using that name keep it until you edit them.',
            style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: newCategoryController,
                maxLength: FieldLimits.category,
                decoration: const InputDecoration(
                  labelText: 'New category',
                  hintText: 'e.g. Beverages',
                  counterText: '',
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAddCategory(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              label: 'Add',
              icon: Symbols.add,
              onPressed: onAddCategory,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onResetCategories,
            child: const Text('Reset category defaults'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (categories.isEmpty)
          Text(
            'No categories yet. Add a few so cashiers can pick them quickly.',
            style: theme.textTheme.bodySmall,
          )
        else
          ScrollableChipWrap(
            maxLines: 6,
            children: categories
                .map(
                  (category) => InputChip(
                    label: Text(category),
                    onDeleted: () => onRemoveCategory(category),
                    deleteIcon: const Icon(Symbols.close, size: 16),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeState>(
      builder: (context, themeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              title: 'Appearance',
              subtitle:
                  'Choose light/dark mode and accent color for your store.',
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Mode', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Symbols.light_mode, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Symbols.dark_mode, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Symbols.contrast, size: 18),
                ),
              ],
              selected: {themeState.mode},
              onSelectionChanged: (value) {
                context.read<ThemeCubit>().setMode(value.first);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Primary color',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sidebar, snackbars, and dark chrome surfaces.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final preset in AppPrimaryPreset.values)
                  _PrimaryPresetTile(
                    preset: preset,
                    selected: themeState.primary == preset,
                    onTap: () => context.read<ThemeCubit>().setPrimary(preset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Accent color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Applies to buttons, sidebar highlights, charts, and POS accents.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final preset in AppAccentPreset.values)
                  _AccentPresetTile(
                    preset: preset,
                    selected: themeState.accent == preset,
                    onTap: () => context.read<ThemeCubit>().setAccent(preset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Theme applies instantly across the app, including the sidebar.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            const _SoundFeedbackSection(),
          ],
        );
      },
    );
  }
}

class _SoundFeedbackSection extends StatefulWidget {
  const _SoundFeedbackSection();

  @override
  State<_SoundFeedbackSection> createState() => _SoundFeedbackSectionState();
}

class _SoundFeedbackSectionState extends State<_SoundFeedbackSection> {
  final _prefs = AppSoundPrefs.instance;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    await _prefs.load();
    if (mounted) setState(() {});
  }

  Future<void> _patch({
    bool? enabled,
    double? volume,
    bool? cartSounds,
    bool? notificationSounds,
    bool? tapSounds,
  }) async {
    await _prefs.update(
      enabled: enabled,
      volume: volume,
      cartSounds: cartSounds,
      notificationSounds: notificationSounds,
      tapSounds: tapSounds,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Sound feedback',
          subtitle: 'Short sounds for cart actions, toasts, and optional taps.',
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable sounds'),
          subtitle: const Text('Master switch for all UI sounds'),
          value: _prefs.enabled,
          onChanged: (v) => _patch(enabled: v),
        ),
        if (_prefs.enabled) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text('Volume', style: theme.textTheme.titleSmall),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Slider(
                  value: _prefs.volume,
                  onChanged: (v) => _patch(volume: v),
                  onChangeEnd: (_) => AppSounds.instance.preview(AppSound.info),
                ),
              ),
              Text('${(_prefs.volume * 100).round()}%'),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Cart sounds'),
            subtitle: const Text('Add, remove, and stock warnings on POS'),
            value: _prefs.cartSounds,
            onChanged: (v) {
              _patch(cartSounds: v);
              if (v) AppSounds.instance.preview(AppSound.cartAdd);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notification sounds'),
            subtitle: const Text('Success, error, and info toasts'),
            value: _prefs.notificationSounds,
            onChanged: (v) {
              _patch(notificationSounds: v);
              if (v) AppSounds.instance.preview(AppSound.success);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Button tap sounds'),
            subtitle: const Text(
              'Soft Apple-style click on AppButton and icon buttons',
            ),
            value: _prefs.tapSounds,
            onChanged: (v) {
              _patch(tapSounds: v);
              if (v) AppSounds.instance.preview(AppSound.tap);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xxs,
            children: [
              for (final sample in AppSound.values)
                OutlinedButton(
                  onPressed: _prefs.enabled
                      ? () => AppSounds.instance.preview(sample)
                      : null,
                  child: Text(_soundLabel(sample)),
                ),
            ],
          ),
        ],
      ],
    );
  }

  String _soundLabel(AppSound sound) => switch (sound) {
    AppSound.tap => 'Tap',
    AppSound.cartAdd => 'Add',
    AppSound.cartRemove => 'Remove',
    AppSound.success => 'Success',
    AppSound.error => 'Error',
    AppSound.info => 'Info',
  };
}

class _AccentPresetTile extends StatelessWidget {
  const _AccentPresetTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AppAccentPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 118,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? preset.accent : Theme.of(context).dividerColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [preset.accent, preset.gradientEnd],
                ),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 6),
              child: selected
                  ? const Icon(Symbols.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              preset.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryPresetTile extends StatelessWidget {
  const _PrimaryPresetTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AppPrimaryPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 118,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? preset.color : Theme.of(context).dividerColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: preset.color,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 6),
              child: selected
                  ? const Icon(Symbols.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              preset.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupSection extends StatelessWidget {
  const _BackupSection({
    required this.lastBackupAt,
    required this.lastBackupPath,
    required this.dateFormat,
    required this.onBackup,
    required this.onImport,
    required this.onClearDatabase,
    this.showClearDatabase = false,
  });

  final DateTime? lastBackupAt;
  final String? lastBackupPath;
  final DateFormat dateFormat;
  final VoidCallback onBackup;
  final VoidCallback onImport;
  final VoidCallback onClearDatabase;
  final bool showClearDatabase;

  Future<void> _confirmImport(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import backup?'),
        content: const Text(
          'This replaces the current local database with the selected '
          'backup file.\n\n'
          'Current products, sales, and settings will be overwritten. '
          'You will be signed out after import.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Import file'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      onImport();
    }
  }

  Future<void> _confirmClearDatabase(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Backup first, then clear?'),
        content: const Text(
          'You must save a backup file first. After the backup succeeds, '
          'business data will be cleared.\n\n'
          'If you cancel the backup dialog, nothing will be deleted.\n\n'
          'This permanently removes products, sales, purchases, customers, '
          'suppliers, finance records, and reports. The database starts empty '
          '(no demo products). User logins are kept, and you will be signed out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save backup & clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      onClearDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Local backup',
          subtitle: 'Export or import the offline database file',
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last backup',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                lastBackupAt == null
                    ? 'No backup taken yet'
                    : dateFormat.format(lastBackupAt!),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (lastBackupPath != null && lastBackupPath!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  lastBackupPath!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: 'Export backup',
              icon: Symbols.upload,
              onPressed: onBackup,
            ),
            AppButton(
              label: 'Import backup',
              icon: Symbols.download,
              variant: AppButtonVariant.secondary,
              onPressed: () => _confirmImport(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Export saves a .isar file you can keep safely. Import replaces '
          'the current database with a previously exported file.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (showClearDatabase) ...[
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            title: 'Remove data',
            subtitle: 'You must save a backup file before data can be cleared',
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forced backup then clear',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Opens the save dialog first. Only after you save a valid '
                  'backup file will business data be cleared. Demo products '
                  'will not come back. Cancel backup = no delete. User logins remain.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Save backup & clear data',
            icon: Symbols.delete_forever,
            variant: AppButtonVariant.danger,
            onPressed: () => _confirmClearDatabase(context),
          ),
        ],
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  Future<void> _copy(BuildContext context, String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      AppToast.show(context, '$label copied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: AppConstants.appName,
          subtitle: 'Version 1.0.0 · Offline-first POS for Pakistan',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Need help, customization, or support? Contact the developer.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        _ContactTile(
          icon: Symbols.person,
          label: 'Developer',
          value: DeveloperContact.developerName,
          onCopy: () => _copy(context, DeveloperContact.developerName, 'Name'),
        ),
        _ContactTile(
          icon: Symbols.mail,
          label: 'Email',
          value: DeveloperContact.email,
          onCopy: () => _copy(context, DeveloperContact.email, 'Email'),
        ),
        _ContactTile(
          icon: Symbols.call,
          label: 'Mobile & WhatsApp',
          value: DeveloperContact.phoneDisplay,
          onCopy: () => _copy(context, DeveloperContact.mobile, 'Phone'),
        ),
        _ContactTile(
          icon: Symbols.location_on,
          label: 'Location',
          value: DeveloperContact.location,
          onCopy: () => _copy(context, DeveloperContact.location, 'Location'),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.chat, size: 18, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Tap copy on any row to paste into email, SMS, or WhatsApp. '
                  'WhatsApp: ${DeveloperContact.whatsApp}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 22),
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: SelectableText(value),
      trailing: IconButton(
        tooltip: 'Copy',
        icon: const Icon(Symbols.content_copy, size: 20),
        onPressed: onCopy,
      ),
    );
  }
}
