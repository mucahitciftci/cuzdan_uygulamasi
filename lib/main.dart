import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_screen.dart'; // Bir sonraki adımda oluşturacağız

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // Hive Veritabanını başlatıyoruz
  await Hive.initFlutter();
  
  // Kullanıcı bilgileri ve uygulama ayarlarını tutacağımız bir 'box' (kutu/tablo) açıyoruz
  await Hive.openBox('auth_box');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/lang',
      fallbackLocale: const Locale('tr'),
      child: const PersonalWalletApp(),
    ),
  );
}

class PersonalWalletApp extends StatelessWidget {
  const PersonalWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Personal Wallet',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      // İlk ekranımız artık Giriş Ekranı olacak!
      home: const LoginScreen(),
    );
  }
}