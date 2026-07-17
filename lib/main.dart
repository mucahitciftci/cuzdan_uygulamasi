import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/asset_model.dart';
import 'models/wallet_model.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(AssetAdapter());
  Hive.registerAdapter(WalletAdapter());
  
  // Hem cüzdanlar hem de ayarlar için kutuları açıyoruz
  await Hive.openBox<Wallet>('wallets_box');
  final settingsBox = await Hive.openBox('settings_box');

  // --- KAYITLI TEMAYI OKUMA VE BAŞLANGIÇTA SET ETME ---
  final bool? isDarkMode = settingsBox.get('isDarkMode') as bool?;
  if (isDarkMode != null) {
    AppTheme.themeModeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Cüzdan Uygulaması',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}