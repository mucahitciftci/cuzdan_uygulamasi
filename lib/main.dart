import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('tr'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Tema her değiştiğinde MyApp widget'ını zorunlu olarak yeniden çizdiriyoruz
    AppTheme.themeNotifier.addListener(_themeListener);
  }

  @override
  void dispose() {
    AppTheme.themeNotifier.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    setState(() {}); // En üst seviyede ekranı yeniden çizerek temayı anında uygular
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeNotifier.value, // Güncel tema modu değerini veriyoruz
      home: const LoginScreen(),
    );
  }
}