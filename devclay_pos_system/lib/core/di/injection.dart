import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../database/isar_service.dart';
import '../../modules/auth/data/auth_repository_impl.dart';
import '../../modules/auth/data/datasources/auth_local_datasource.dart';
import '../../modules/auth/domain/repositories/auth_repository.dart';
import '../../modules/auth/domain/usecases/auth_usecases.dart';
import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../platform/native_capabilities.dart';
import '../../modules/license/data/datasources/license_local_datasource.dart';
import '../../modules/license/data/datasources/license_remote_datasource.dart';
import '../../modules/license/data/datasources/firestore_rest_license_remote_datasource.dart';
import '../../modules/license/data/license_repository_impl.dart';
import '../../modules/license/domain/repositories/license_repository.dart';
import '../../modules/license/presentation/bloc/license_bloc.dart';
import '../../modules/dashboard/data/dashboard_repository_impl.dart';
import '../../modules/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../modules/dashboard/domain/repositories/dashboard_repository.dart';
import '../../modules/dashboard/domain/usecases/get_dashboard_data.dart';
import '../../modules/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../modules/pos/data/datasources/pos_local_datasource.dart';
import '../../modules/pos/data/pos_repository_impl.dart';
import '../../modules/pos/domain/repositories/pos_repository.dart';
import '../../modules/pos/presentation/bloc/pos_bloc.dart';
import '../../modules/recycle_bin/data/datasources/recycle_bin_local_datasource.dart';
import '../../modules/recycle_bin/data/recycle_bin_repository_impl.dart';
import '../../modules/recycle_bin/domain/repositories/recycle_bin_repository.dart';
import '../../modules/inventory/data/datasources/inventory_local_datasource.dart';
import '../../modules/inventory/data/inventory_repository_impl.dart';
import '../../modules/inventory/domain/repositories/inventory_repository.dart';
import '../../modules/inventory/presentation/bloc/inventory_bloc.dart';
import '../../modules/labels/data/datasources/labels_local_datasource.dart';
import '../../modules/labels/data/labels_repository_impl.dart';
import '../../modules/labels/domain/repositories/labels_repository.dart';
import '../../modules/labels/presentation/bloc/labels_bloc.dart';
import '../../services/labels/label_print_engine.dart';
import '../../modules/settings/data/datasources/settings_local_datasource.dart';
import '../../modules/settings/data/settings_repository_impl.dart';
import '../../modules/settings/domain/repositories/settings_repository.dart';
import '../../modules/settings/presentation/bloc/settings_bloc.dart';
import '../../modules/users/data/datasources/users_local_datasource.dart';
import '../../modules/users/data/users_repository_impl.dart';
import '../../modules/users/domain/repositories/users_repository.dart';
import '../../modules/users/presentation/bloc/users_bloc.dart';
import '../../modules/reports/data/datasources/reports_local_datasource.dart';
import '../../modules/reports/data/datasources/reports_query_engine.dart';
import '../../modules/reports/data/reports_repository_impl.dart';
import '../../modules/reports/domain/repositories/reports_repository.dart';
import '../../modules/reports/presentation/bloc/reports_bloc.dart';
import '../../modules/accounts/data/datasources/accounts_local_datasource.dart';
import '../../modules/accounts/data/accounts_repository_impl.dart';
import '../../modules/accounts/domain/repositories/accounts_repository.dart';
import '../../modules/accounts/presentation/bloc/accounts_bloc.dart';
import '../../modules/finance/data/datasources/finance_local_datasource.dart';
import '../../modules/finance/data/finance_repository_impl.dart';
import '../../modules/finance/domain/repositories/finance_repository.dart';
import '../../modules/finance/presentation/bloc/finance_bloc.dart';
import '../../modules/suppliers/data/datasources/suppliers_local_datasource.dart';
import '../../modules/suppliers/data/suppliers_repository_impl.dart';
import '../../modules/suppliers/domain/repositories/suppliers_repository.dart';
import '../../modules/suppliers/presentation/bloc/suppliers_bloc.dart';
import '../../modules/customers/data/datasources/customers_local_datasource.dart';
import '../../modules/customers/data/customers_repository_impl.dart';
import '../../modules/customers/domain/repositories/customers_repository.dart';
import '../../modules/customers/presentation/bloc/customers_bloc.dart';
import '../../modules/sales/data/datasources/sales_local_datasource.dart';
import '../../modules/sales/data/sales_repository_impl.dart';
import '../../modules/sales/domain/repositories/sales_repository.dart';
import '../../modules/sales/presentation/bloc/sales_bloc.dart';
import '../../modules/purchases/data/datasources/purchases_local_datasource.dart';
import '../../modules/purchases/data/purchases_repository_impl.dart';
import '../../modules/purchases/domain/repositories/purchases_repository.dart';
import '../../modules/purchases/presentation/bloc/purchases_bloc.dart';
import '../../modules/products/data/datasources/products_local_datasource.dart';
import '../../modules/products/data/products_repository_impl.dart';
import '../../modules/products/domain/repositories/products_repository.dart';
import '../../modules/products/presentation/bloc/products_bloc.dart';
import '../../modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import '../../routes/app_router.dart';
import '../../services/hardware/desktop_hardware_service.dart';
import '../../services/hardware/hardware_service.dart';
import '../../services/media/product_image_store.dart';
import '../../services/retail/retail_control_service.dart';
import '../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../themes/app_theme_presets.dart';
import '../../themes/theme_cubit.dart';
import '../store_profile/store_profile_service.dart';
import '../lan/lan_mode_service.dart';
import '../lan/shop_host_server.dart';
import '../lan/lan_api_client.dart';
import '../lan_api/host/sale_write_service.dart';
import '../lan_api/client/lan_connection_monitor.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  final isarService = IsarService();
  await isarService.open();
  sl.registerSingleton<IsarService>(isarService);
  sl.registerLazySingleton<StoreProfileService>(
    () => StoreProfileService(sl()),
  );
  await sl<StoreProfileService>().load();
  sl.registerLazySingleton<LanModeService>(() => LanModeService());
  await sl<LanModeService>().load();
  sl.registerLazySingleton<SaleWriteService>(() => SaleWriteService(sl()));
  sl.registerLazySingleton<RestaurantLocalDataSource>(
    () => RestaurantLocalDataSource(sl()),
  );
  sl.registerLazySingleton<ShopHostServer>(
    () => ShopHostServer(sl(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<LanApiClient>(() {
    final client = LanApiClient(sl());
    unawaited(client.loadToken());
    return client;
  });
  sl.registerLazySingleton<LanConnectionMonitor>(
    () => LanConnectionMonitor(sl(), sl()),
  );
  if (sl<LanModeService>().isHost) {
    unawaited(sl<ShopHostServer>().start());
  }
  if (sl<LanModeService>().isClient) {
    unawaited(sl<LanConnectionMonitor>().refresh());
  }
  sl.registerLazySingleton<RetailControlService>(
    () => RetailControlService(sl()),
  );

  sl.registerLazySingleton<HardwareService>(DesktopHardwareService.new);
  sl.registerLazySingleton<ProductImageStore>(ProductImageStore.new);

  sl.registerLazySingleton<LicenseLocalDataSource>(LicenseLocalDataSource.new);
  sl.registerLazySingleton<LicenseRemoteDataSource>(
    () => NativeCapabilities.isFirebaseDesktopSafe
        ? FirestoreLicenseRemoteDataSource()
        : FirestoreRestLicenseRemoteDataSource(),
  );
  sl.registerLazySingleton<LicenseRepository>(
    () => LicenseRepositoryImpl(local: sl(), remote: sl()),
  );
  sl.registerLazySingleton<LicenseBloc>(() => LicenseBloc(sl()));

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RestoreSession>(() => RestoreSession(sl()));
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<GetStores>(() => GetStores(sl()));
  sl.registerLazySingleton<SelectStore>(() => SelectStore(sl()));
  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(sl()));
  sl.registerLazySingleton<RefreshSession>(() => RefreshSession(sl()));
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      restoreSession: sl(),
      loginUser: sl(),
      getStores: sl(),
      selectStore: sl(),
      logoutUser: sl(),
      refreshSession: sl(),
    ),
  );

  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSource(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetDashboardData>(() => GetDashboardData(sl()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl()));

  sl.registerLazySingleton<PosLocalDataSource>(() => PosLocalDataSource(sl()));
  sl.registerLazySingleton<PosRepository>(() => PosRepositoryImpl(sl()));
  sl.registerFactory<PosBloc>(() => PosBloc(sl()));

  sl.registerLazySingleton<ProductsLocalDataSource>(
    () => ProductsLocalDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(sl()),
  );
  sl.registerFactory<ProductsBloc>(() => ProductsBloc(sl()));

  sl.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSource(sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(sl()),
  );
  sl.registerFactory<InventoryBloc>(() => InventoryBloc(sl()));

  sl.registerLazySingleton<PurchasesLocalDataSource>(
    () => PurchasesLocalDataSource(sl()),
  );
  sl.registerLazySingleton<PurchasesRepository>(
    () => PurchasesRepositoryImpl(sl()),
  );
  sl.registerFactory<PurchasesBloc>(() => PurchasesBloc(sl()));

  sl.registerLazySingleton<SalesLocalDataSource>(
    () => SalesLocalDataSource(sl()),
  );
  sl.registerLazySingleton<SalesRepository>(() => SalesRepositoryImpl(sl()));
  sl.registerFactory<SalesBloc>(() => SalesBloc(sl()));

  sl.registerLazySingleton<CustomersLocalDataSource>(
    () => CustomersLocalDataSource(sl()),
  );
  sl.registerLazySingleton<CustomersRepository>(
    () => CustomersRepositoryImpl(sl()),
  );
  sl.registerFactory<CustomersBloc>(() => CustomersBloc(sl()));

  sl.registerLazySingleton<SuppliersLocalDataSource>(
    () => SuppliersLocalDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<SuppliersRepository>(
    () => SuppliersRepositoryImpl(sl()),
  );
  sl.registerFactory<SuppliersBloc>(() => SuppliersBloc(sl()));

  sl.registerLazySingleton<AccountsLocalDataSource>(
    () => AccountsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(sl()),
  );
  sl.registerFactory<AccountsBloc>(() => AccountsBloc(sl()));

  sl.registerLazySingleton<FinanceLocalDataSource>(
    () => FinanceLocalDataSource(sl()),
  );
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(sl()),
  );
  sl.registerFactory<FinanceBloc>(() => FinanceBloc(sl()));

  sl.registerLazySingleton<ReportsQueryEngine>(() => ReportsQueryEngine(sl()));
  sl.registerLazySingleton<ReportsLocalDataSource>(
    () => ReportsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(sl()),
  );
  sl.registerFactory<ReportsBloc>(() => ReportsBloc(sl()));

  sl.registerLazySingleton<UsersLocalDataSource>(
    () => UsersLocalDataSource(sl()),
  );
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));

  sl.registerFactoryParam<UsersBloc, int, String>(
    (currentUserId, currentUserRole) => UsersBloc(
      sl(),
      currentUserId: currentUserId,
      currentUserRole: currentUserRole,
    ),
  );

  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  unawaited(
    sl<SettingsLocalDataSource>().autoBackupIfDue().catchError((_) => null),
  );
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(sl()));

  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(
      onPersist: (state) => sl<SettingsRepository>().saveThemePreference(
        themeMode: AppThemeModeCodec.encode(state.mode),
        accentPreset: state.accent.id,
        primaryPreset: state.primary.id,
      ),
    ),
  );
  final themeSettings = await sl<SettingsRepository>().getSettings();
  sl<ThemeCubit>().load(
    mode: AppThemeModeCodec.decode(themeSettings.themeMode),
    accent: AppAccentPreset.fromId(themeSettings.accentPreset),
    primary: AppPrimaryPreset.fromId(themeSettings.primaryPreset),
  );

  sl.registerLazySingleton<NotificationsCubit>(() => NotificationsCubit(sl()));
  await sl<NotificationsCubit>().refresh();

  sl.registerLazySingleton<LabelPrintEngine>(LabelPrintEngine.new);
  sl.registerLazySingleton<LabelsLocalDataSource>(
    () => LabelsLocalDataSource(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<LabelsRepository>(
    () => LabelsRepositoryImpl(sl(), sl()),
  );
  sl.registerFactory<LabelsBloc>(() => LabelsBloc(sl(), sl()));

  sl.registerLazySingleton<RecycleBinLocalDataSource>(
    () => RecycleBinLocalDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<RecycleBinRepository>(
    () => RecycleBinRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GoRouter>(createAppRouter);
}
