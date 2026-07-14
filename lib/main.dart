import 'package:flutter/material.dart';
import 'package:cuzdan_uygulamasi/screens/cuzdan_listesi_ekrani.dart';

void main() {
  runApp(const CuzdanUygulamasiApp());
}

class CuzdanUygulamasiApp extends StatelessWidget {
  const CuzdanUygulamasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kişisel Cüzdan',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: const CuzdanListesiEkrani(),
    );
  }
}