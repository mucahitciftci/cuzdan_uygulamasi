import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cuzdan_uygulamasi/screens/wallet_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
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
      home: const WalletListScreen(),
    );
  }
}