import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Yeni import
import '../models/cuzdan_model.dart';

class CuzdanListesiEkrani extends StatefulWidget {
  const CuzdanListesiEkrani({super.key});

  @override
  State<CuzdanListesiEkrani> createState() => _CuzdanListesiEkraniState();
}

class _CuzdanListesiEkraniState extends State<CuzdanListesiEkrani> {
  final List<Cuzdan> _cuzdanlar = [];
  final TextEditingController _adController = TextEditingController();

  void _cuzdanEklemeDialogGoster() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('dialog_title'.tr()), // JSON'dan çekilen başlık
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _adController,
              decoration: InputDecoration(
                labelText: 'wallet_name_label'.tr(), // JSON'dan etiket
                hintText: 'wallet_name_hint'.tr(),   // JSON'dan ipucu
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _adController.clear();
              Navigator.of(ctx).pop();
            },
            child: Text('button_cancel'.tr()), // JSON'dan İptal
          ),
          ElevatedButton(
            onPressed: () {
              if (_adController.text.trim().isEmpty) return;
              
              setState(() {
                _cuzdanlar.add(
                  Cuzdan(
                    id: DateTime.now().toString(),
                    cuzdanAdi: _adController.text.trim(),
                  ),
                );
              });

              _adController.clear();
              Navigator.of(ctx).pop();
            },
            child: Text('button_add'.tr()), // JSON'dan Ekle
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()), // JSON'dan uygulama başlığı
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Test etmek için sağ üste dil değiştirme butonu koyalım
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (context.locale == const Locale('tr')) {
                context.setLocale(const Locale('en'));
              } else {
                context.setLocale(const Locale('tr'));
              }
            },
          ),
        ],
      ),
      body: _cuzdanlar.isEmpty
          ? Center(
              child: Text(
                'empty_wallets'.tr(), // JSON'dan boş ekran uyarısı
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _cuzdanlar.length,
              itemBuilder: (context, index) {
                final cuzdan = _cuzdanlar[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.wallet, color: Colors.white),
                    ),
                    title: Text(
                      cuzdan.cuzdanAdi,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cuzdanEklemeDialogGoster,
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}