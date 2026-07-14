import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/wallet_model.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  // English naming for state variables
  final List<Wallet> _wallets = [];
  final TextEditingController _nameController = TextEditingController();

  // Shows the dialog to add a new wallet
  void _showAddWalletDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('dialog_title'.tr()), // Localization key
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'wallet_name_label'.tr(),
                hintText: 'wallet_name_hint'.tr(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              Navigator.of(ctx).pop();
            },
            child: Text('button_cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) return;
              
              setState(() {
                _wallets.add(
                  Wallet(
                    id: DateTime.now().toString(),
                    walletName: _nameController.text.trim(),
                  ),
                );
              });

              _nameController.clear();
              Navigator.of(ctx).pop();
            },
            child: Text('button_add'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose(); // Prevents memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Language switcher button for testing
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
      body: _wallets.isEmpty
          ? Center(
              child: Text(
                'empty_wallets'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _wallets.length,
              itemBuilder: (context, index) {
                final wallet = _wallets[index];
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
                      wallet.walletName,
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
        onPressed: _showAddWalletDialog,
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}