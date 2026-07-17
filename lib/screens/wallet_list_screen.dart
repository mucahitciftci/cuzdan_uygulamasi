import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<Wallet> _wallets = [];
  final TextEditingController _nameController = TextEditingController();
  
  // Hardcode anahtar kullanımı engellemek için statik sabit tanımlandı
  static const String _storageKey = 'saved_wallets';
  static const String _defaultCurrency = '₺';
  
  String _selectedCurrency = _defaultCurrency;

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  // --- HAFIZADAN CÜZDANLARI YÜKLEME ---
  void _loadWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? walletsJson = prefs.getString(_storageKey); // Sabit kullanıldı
    
    if (walletsJson != null) {
      final List<dynamic> decodedList = jsonDecode(walletsJson);
      setState(() {
        _wallets.clear();
        _wallets.addAll(
          decodedList.map((item) => Wallet.fromJson(item as Map<String, dynamic>)).toList()
        );
      });
    }
  }

  // --- HAFIZAYA CÜZDANLARI KAYDETME ---
  void _saveWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _wallets.map((wallet) => wallet.toJson()).toList()
    );
    await prefs.setString(_storageKey, encodedData); // Sabit kullanıldı
  }

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
                  DropdownMenuItem(value: '₺', child: Text('Türk Lirası (₺)', style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: '\$', child: Text('US Dollar (\$)', style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: '€', child: Text('Euro (€)', style: TextStyle(color: textColor))),
                  DropdownMenuItem(value: 'g', child: Text('Altın (g)', style: TextStyle(color: textColor))),
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

                _saveWallets();
                _nameController.clear();
                _selectedCurrency = _defaultCurrency; // Sabit kullanıldı
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
          'delete_wallet_message'.tr(args: [_wallets[index].walletName]),
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
            onPressed: () {
              setState(() {
                _wallets.removeAt(index);
              });
              _saveWallets();
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
                  tooltip: isDark ? 'Koyu Tema / Dark Theme' : 'Açık Tema / Light Theme',
                  onPressed: () {
                    setState(() {
                      AppTheme.toggleTheme();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.language, color: textColor),
                  onPressed: () {
                    if (context.locale == const Locale('tr')) {
                      context.setLocale(const Locale('en'));
                    } else {
                      context.setLocale(const Locale('tr'));
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
          child: _wallets.isEmpty
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
                                wallet.currencySymbol == 'g' ? 'Au' : wallet.currencySymbol,
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => WalletDetailScreen(wallet: wallet),
                                ),
                              );
                              // Detay ekranında yapılan (ekleme/silme) değişikliklerin web arayüzünde 
                              // anında güncellenip kalıcı hafızaya yazılması için setState içine alındı!
                              setState(() {
                                _saveWallets();
                              });
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
  }
}