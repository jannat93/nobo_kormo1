import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nobo_kormo/providers/auth_provider.dart';
import 'package:nobo_kormo/providers/data_provider.dart';
import 'package:nobo_kormo/providers/social_provider.dart';
import 'package:nobo_kormo/screens/auth/auth_screen.dart';
import 'package:nobo_kormo/screens/main/main_screen.dart';
import 'config/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SocialProvider()),
      ],
      child: const CareerApp(),
    ),
  );
}

class CareerApp extends StatelessWidget {
  const CareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nobokormo Career App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: accentColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        // ✅ FIXED HERE
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return auth.isAuthenticated
              ? const MainScreen()
              : const AuthScreen();
        },
      ),
    );
  }
}
