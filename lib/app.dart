import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/core/constants/app_constants.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/ble_provider.dart';
import 'package:envqmon/presentation/providers/home_provider.dart';
import 'package:envqmon/presentation/providers/room_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/screens/splash_screen.dart';
import 'package:envqmon/presentation/screens/auth/login_screen.dart';
import 'package:envqmon/presentation/screens/main/dashboard_screen.dart';
import 'package:envqmon/data/repositories/auth_repository.dart';
import 'package:envqmon/data/repositories/ble_repository.dart';
import 'package:envqmon/data/repositories/home_repository.dart';
import 'package:envqmon/data/repositories/room_repository.dart';
import 'package:envqmon/data/repositories/device_repository.dart';
import 'package:envqmon/data/datasources/local_storage_service.dart';

class EnvQMonApp extends StatelessWidget {
  const EnvQMonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorageService>(
          create: (_) => LocalStorageService(),
        ),
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<BleRepository>(
          create: (_) => BleRepository(),
        ),
        Provider<HomeRepository>(
          create: (_) => HomeRepository(),
        ),
        Provider<RoomRepository>(
          create: (_) => RoomRepository(),
        ),
        Provider<DeviceRepository>(
          create: (_) => DeviceRepository(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
            localStorage: context.read<LocalStorageService>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BleProvider>(
          create: (context) => BleProvider(
            bleRepository: context.read<BleRepository>(),
          ),
          update: (context, authProvider, previous) => previous ?? BleProvider(
            bleRepository: context.read<BleRepository>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
          create: (context) => HomeProvider(
            homeRepository: context.read<HomeRepository>(),
          ),
          update: (context, authProvider, previous) => previous ?? HomeProvider(
            homeRepository: context.read<HomeRepository>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RoomProvider>(
          create: (context) => RoomProvider(
            roomRepository: context.read<RoomRepository>(),
          ),
          update: (context, authProvider, previous) => previous ?? RoomProvider(
            roomRepository: context.read<RoomRepository>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DeviceProvider>(
          create: (context) => DeviceProvider(
            deviceRepository: context.read<DeviceRepository>(),
          ),
          update: (context, authProvider, previous) => previous ?? DeviceProvider(
            deviceRepository: context.read<DeviceRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: AppConstants.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            primary: AppConstants.primaryColor,
            secondary: AppConstants.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.largePadding,
                vertical: AppConstants.defaultPadding,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
