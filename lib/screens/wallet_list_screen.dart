import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/wallet_model.dart';
import 'wallet_detail_screen.dart';
import 'login_screen.dart';

class WalletListScreen extends StatefulWidget {
  final String username;

  const WalletListScreen({super.key, required this.username});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  final List<Wallet> _wallets = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedCurrency = '₺';

  void _showAddWalletDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.blueGrey.shade900.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
          ),
          title: Text(
            'dialog_title'.tr(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'wallet_name_label'.tr(),
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  hintText: 'wallet_name_hint'.tr(),
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                dropdownColor: Colors.blueGrey.shade900,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'currency_label'.tr(),
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: '₺', child: Text('Türk Lirası (₺)', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: '\$', child: Text('US Dollar (\$)', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: '€', child: Text('Euro (€)', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'g', child: Text('Altın (g)', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      _selectedCurrency = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                Navigator.of(ctx).pop();
              },
              child: Text('button_cancel'.tr(), style: TextStyle(color: Colors.tealAccent.shade400)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent.shade400,
                foregroundColor: Colors.blueGrey.shade900,
              ),
              onPressed: () {
                if (_nameController.text.trim().isEmpty) return;
                
                setState(() {
                  _wallets.add(
                    Wallet(
                      id: DateTime.now().toString(),
                      walletName: _nameController.text.trim(),
                      currencySymbol: _selectedCurrency,
                      assets: [],
                    ),
                  );
                });

                _nameController.clear();
                _selectedCurrency = '₺';
                Navigator.of(ctx).pop();
              },
              child: Text('button_add'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteWallet(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        title: Text(
          'delete_wallet_title'.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'delete_wallet_message'.tr(args: [_wallets[index].walletName]),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('button_cancel'.tr(), style: TextStyle(color: Colors.tealAccent.shade400)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                _wallets.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        // --- YENİLİK: Başlığı Havalı Bir Cam Blok İçine Aldık ---
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              title: Text(
                'app_title'.tr(args: [widget.username]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 1.2,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.05), // Hafif saydam blok arka planı
              elevation: 0,
              centerTitle: true,
              shape: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1), // Alt ince parıltılı sınır çizgisi
                  width: 1,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onPressed: () {
                    if (context.locale == const Locale('tr')) {
                      context.setLocale(const Locale('en'));
                    } else {
                      context.setLocale(const Locale('tr'));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        // --- YENİLİK: Daha Açık, Tatlı ve Ferah Renk Geçişleri ---
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade900,
              Colors.blueGrey.shade700, // Daha açık tonda gri-mavi
              Colors.teal.shade900,      // Boğucu lacivert yerine asil teal geçişi
            ],
          ),
        ),
        child: SafeArea(
          child: _wallets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Colors.tealAccent.shade400.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'empty_wallets'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16, 
                          color: Colors.white.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: _wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = _wallets[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: Colors.tealAccent.shade400.withValues(alpha: 0.2),
                              child: Text(
                                wallet.currencySymbol == 'g' ? 'Au' : wallet.currencySymbol,
                                style: TextStyle(
                                  color: Colors.tealAccent.shade400, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: Text(
                              wallet.walletName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => _confirmDeleteWallet(index),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white60,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => WalletDetailScreen(wallet: wallet),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWalletDialog,
        backgroundColor: Colors.tealAccent.shade400,
        child: Icon(Icons.add, color: Colors.blueGrey.shade900),
      ),
    );
  }
}