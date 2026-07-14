import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cuzdan_uygulamasi/screens/cuzdan_listesi_ekrani.dart';

void main() async {
  // Flutter widget'larının yüklenmesini garanti altına alıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/lang', // Dil dosyalarımızın yolu
      fallbackLocale: const Locale('en'), // Telefon dili desteklenmiyorsa varsayılan dil (İngilizce)
      child: const CuzdanUygulamasiApp(),
    ),
  );
}

class CuzdanUygulamasiApp extends StatelessWidget {
  const CuzdanUygulamasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // easy_localization paketinin dil ayarlarını uygulamaya bağlıyoruz
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      debugShowCheckedModeBanner: false,
      title: 'Kişisel Cüzdan',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const CuzdanListesiEkrani(),
    );
  }
}