import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_constants.dart';
import 'core/di/injection.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/license/presentation/bloc/license_bloc.dart';
import 'modules/notifications/presentation/cubit/notifications_cubit.dart';
import 'themes/app_colors.dart';
import 'themes/app_theme.dart';
import 'themes/theme_cubit.dart';

class DevClayPosApp extends StatefulWidget {
  const DevClayPosApp({super.key});

  @override
  State<DevClayPosApp> createState() => _DevClayPosAppState();
}

class _DevClayPosAppState extends State<DevClayPosApp> {
  @override
  void initState() {
    super.initState();
    sl<LicenseBloc>().add(const LicenseStarted());
    sl<AuthBloc>().add(const AuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LicenseBloc>()),
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<NotificationsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeState>(
        builder: (context, themeState) {
          // Apply tokens before building ThemeData so Material matches selection.
          AppColors.applyPresets(
            accent: themeState.accent,
            primary: themeState.primary,
          );
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeState.mode,
            routerConfig: sl<GoRouter>(),
          );
        },
      ),
    );
  }
}
