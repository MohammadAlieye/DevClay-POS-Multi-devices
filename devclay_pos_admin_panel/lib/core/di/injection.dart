import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/data/admin_auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/admin_auth_repository.dart';
import '../../modules/auth/presentation/bloc/admin_auth_bloc.dart';
import '../../modules/licenses/data/admin_license_repository.dart';
import '../../routes/app_router.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<AdminAuthRepository>(AdminAuthRepositoryImpl.new);
  sl.registerLazySingleton<AdminLicenseRepository>(AdminLicenseRepository.new);
  sl.registerLazySingleton<AdminAuthBloc>(() => AdminAuthBloc(sl()));
  sl.registerLazySingleton<GoRouter>(createAdminRouter);
}
