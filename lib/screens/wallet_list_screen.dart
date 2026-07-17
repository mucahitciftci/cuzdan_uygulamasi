import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/wallet_model.dart';
import '../theme/app_theme.dart';
import 'wallet_detail_screen.dart';
import 'login_screen.dart';

class WalletListScreen extends StatefulWidget {
  final String username;

  const WalletListScreen({super.key, required this.username});

  @override
  State<WalletListScreen> createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();
  
  static const String _boxWalletsName = 'wallets_box';
  static const String _currencyTry = '₺';
  static const String _currencyUsd = '\$';
  static const String _currencyEur = '€';
  static const String _currencyGold = 'g';
  
  static const String _keyLangTr = 'tr';
  static const String _keyLangEn = 'en';
  static const String _labelTry = 'Türk Lirası (₺)';
  static const String _labelUsd = 'US Dollar (\$)';
  static const String _labelEur = 'Euro (€)';
  static const String _labelGold = 'Altın (g)';
  static const String _textGoldSymbol = 'Au';

  final Box<Wallet> _walletBox = Hive.box<Wallet>(_boxWalletsName);
  String _selectedCurrency = _currencyTry;

  void _showAddWalletDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dialogBg = isDark ? Colors.blueGrey.shade900 : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dialogBg.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: textColor.withValues(alpha: 0.15)),
          ),
          title: Text(
            'dialog_title'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'wallet_name_label'.tr(),
                  labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                  hintText: 'wallet_name_hint'.tr(),
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: _selectedCurrency,
                dropdownColor: dialogBg,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'currency_label'.tr(),
                  labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: _currencyTry, child: Text(_labelTry, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyUsd, child: Text(_labelUsd, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyEur, child: Text(_labelEur, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyGold, child: Text(_labelGold, style: TextStyle(color: textColor))),
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
              child: Text('button_cancel'.tr(), style: TextStyle(color: theme.primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: isDark ? Colors.blueGrey.shade900 : Colors.white,
              ),
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) return;
                
                final newWallet = Wallet(
                  id: DateTime.now().toString(),
                  walletName: _nameController.text.trim(),
                  currencySymbol: _selectedCurrency,
                  assets: [],
                );

                await _walletBox.add(newWallet);
                await _walletBox.flush();

                _nameController.clear();
                _selectedCurrency = _currencyTry;
                
                if (!context.mounted) return;
                Navigator.of(ctx).pop();
              },
              child: Text('button_add'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEM İSİM HEM PARA BİRİMİ SEÇENEKLİ DÜZENLEME POP-UP'I ---
  void _showEditWalletDialog(int index, Wallet wallet) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dialogBg = isDark ? Colors.blueGrey.shade900 : Colors.white;

    _editNameController.text = wallet.walletName;
    String editSelectedCurrency = wallet.currencySymbol;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dialogBg.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: textColor.withValues(alpha: 0.15)),
          ),
          title: const Text(
            'Cüzdanı Düzenle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editNameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Yeni Cüzdan Adı',
                  labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: editSelectedCurrency,
                dropdownColor: dialogBg,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'currency_label'.tr(),
                  labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: _currencyTry, child: Text(_labelTry, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyUsd, child: Text(_labelUsd, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyEur, child: Text(_labelEur, style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: _currencyGold, child: Text(_labelGold, style: TextStyle(color: textColor))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      editSelectedCurrency = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editNameController.clear();
                Navigator.of(ctx).pop();
              },
              child: Text('button_cancel'.tr(), style: TextStyle(color: theme.primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: isDark ? Colors.blueGrey.shade900 : Colors.white,
              ),
              onPressed: () async {
                final newName = _editNameController.text.trim();
                if (newName.isEmpty) return;

                wallet.walletName = newName;
                wallet.currencySymbol = editSelectedCurrency;
                
                await wallet.save();
                await _walletBox.flush();

                _editNameController.clear();
                if (!context.mounted) return;
                Navigator.of(ctx).pop();
              },
              child: const Text('Güncelle', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteWallet(int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dialogBg = isDark ? Colors.blueGrey.shade900 : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: textColor.withValues(alpha: 0.15)),
        ),
        title: Text(
          'delete_wallet_title'.tr(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'delete_wallet_message'.tr(args: [_walletBox.getAt(index)!.walletName]),
          style: TextStyle(color: textColor.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('button_cancel'.tr(), style: TextStyle(color: theme.primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () async {
              await _walletBox.deleteAt(index);
              await _walletBox.flush();
              
              if (!context.mounted) return;
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _editNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = theme.primaryColor;

    final gradientColors = isDark
        ? [Colors.blueGrey.shade900, Colors.blueGrey.shade700, Colors.teal.shade900]
        : [Colors.teal.shade50, Colors.blueGrey.shade50, Colors.white];

    return ValueListenableBuilder(
      valueListenable: _walletBox.listenable(),
      builder: (context, Box<Wallet> box, _) {
        final wallets = box.values.toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: AppBar(
                  title: Text(
                    'app_title'.tr(args: [widget.username]),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1.2,
                      color: textColor,
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: textColor.withValues(alpha: 0.05),
                  elevation: 0,
                  centerTitle: true,
                  shape: Border(
                    bottom: BorderSide(
                      color: textColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          AppTheme.toggleTheme();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.language, color: textColor),
                      onPressed: () {
                        if (context.locale == const Locale(_keyLangTr)) {
                          context.setLocale(const Locale(_keyLangEn));
                        } else {
                          context.setLocale(const Locale(_keyLangTr));
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: textColor),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: SafeArea(
              child: wallets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 80,
                            color: primaryColor.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'empty_wallets'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16, 
                              color: textColor.withValues(alpha: 0.6),
                              height: 1.5,
                            ),
                          ),
                        ],
                      )
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        final wallet = wallets[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: textColor.withValues(alpha: 0.12),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor.withValues(alpha: 0.2),
                                  child: Text(
                                    wallet.currencySymbol == _currencyGold ? _textGoldSymbol : wallet.currencySymbol,
                                    style: TextStyle(
                                      color: primaryColor, 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  wallet.walletName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
                                      onPressed: () => _showEditWalletDialog(index, wallet),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                                      onPressed: () => _confirmDeleteWallet(index),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: textColor.withValues(alpha: 0.6),
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
            backgroundColor: primaryColor,
            child: Icon(Icons.add, color: isDark ? Colors.blueGrey.shade900 : Colors.white),
          ),
        );
      },
    );
  }
}