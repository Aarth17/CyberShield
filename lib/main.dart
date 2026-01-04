import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/auth_provider.dart';
import 'providers/vault_provider.dart';
import 'screens/dashboard_screen.dart';
import 'models/vault_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(VaultItemAdapter());
  await Hive.openBox<VaultItem>('vault');

  // System UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CyberShieldApp());
}

class CyberShieldApp extends StatelessWidget {
  const CyberShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<VaultProvider>(
          create: (_) => VaultProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'CyberShield Security',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const DashboardScreen(),
      ),
    );
  }

  /// App Theme
  ThemeData _buildTheme() {
    const primary = Color(0xFF00F5FF);
    const background = Color(0xFF0A0E27);
    const surface = Color(0xFF1A1F3A);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF6C63FF),
        surface: surface,
        background: background,
      ),

      /// ✅ FIXED: CardThemeData (NOT CardTheme)
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: primary.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primary.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primary,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
