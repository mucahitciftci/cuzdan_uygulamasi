import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/wallet_model.dart';
import 'wallet_detail_screen.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({super.key});

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
          title: Text('dialog_title'.tr()),
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
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _selectedCurrency,
                decoration: InputDecoration(
                  labelText: 'currency_label'.tr(),
                ),
                items: [
                  DropdownMenuItem(value: '₺', child: Text('Türk Lirası (₺)')),
                  DropdownMenuItem(value: '\$', child: Text('US Dollar (\$)')),
                  DropdownMenuItem(value: '€', child: Text('Euro (€)')),
                  DropdownMenuItem(value: 'g', child: Text('Altın (g)')),
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
                      currencySymbol: _selectedCurrency,
                      assets: [],
                    ),
                  );
                });

                _nameController.clear();
                _selectedCurrency = '₺';
                Navigator.of(ctx).pop();
              },
              child: Text('button_add'.tr()),
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
        title: Text('delete_wallet_title'.tr()),
        content: Text('delete_wallet_message'.tr(args: [_wallets[index].walletName])),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('button_cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _wallets.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(color: Colors.white)),
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
      appBar: AppBar(
        title: Text('app_title'.tr()),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
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
                    contentPadding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        wallet.currencySymbol == 'g' ? 'Au' : wallet.currencySymbol,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      wallet.walletName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                          color: Colors.grey,
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