import 'package:flutter/material.dart';
import '../models/cuzdan_model.dart';

class CuzdanListesiEkrani extends StatefulWidget {
  const CuzdanListesiEkrani({super.key});

  @override
  State<CuzdanListesiEkrani> createState() => _CuzdanListesiEkraniState();
}

class _CuzdanListesiEkraniState extends State<CuzdanListesiEkrani> {
  // Başlangıçta listemiz boş
  final List<Cuzdan> _cuzdanlar = [];

  final TextEditingController _adController = TextEditingController();

  // Yeni cüzdan ekleme penceresi (Artık çok daha sade!)
  void _cuzdanEklemeDialogGoster() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Cüzdan Oluştur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _adController,
              decoration: const InputDecoration(
                labelText: 'Cüzdan Adı',
                hintText: 'Örn: Akbank Hesabım, Fiziksel Cüzdan',
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
            child: const Text('İptal'),
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
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _adController.dispose(); // Bellek sızıntısını önlemek için controller'ı kapatıyoruz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💼 Kişisel Cüzdanlarım'),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _cuzdanlar.isEmpty
          ? const Center(
              child: Text(
                'Henüz bir cüzdan eklemediniz.\nSağ alttaki butondan hemen ekleyin!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      child: Icon(Icons.account_balance_wallet, color: Colors.white),
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
                    onTap: () {
                      // İleride tıklanınca varlık ekleme sayfasına gideceğiz
                    },
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