import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/wallet_model.dart';
import '../models/asset_model.dart';

class WalletDetailScreen extends StatefulWidget {
  final Wallet wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _totalInvestedController = TextEditingController(); // Kullanıcının yatırdığı toplam tutar girdisi
  String _selectedUnitType = 'piece';

  // Modelindeki totalValue getter'ını kullanarak toplam bakiyeyi dinamik hesaplıyoruz
  double get _totalBalance {
    double total = 0;
    for (var asset in widget.wallet.assets) {
      total += asset.totalValue; 
    }
    return total;
  }

  void _showAddAssetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.blueGrey.shade900.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)), // HATA DÜZELTİLDİ: border yerine side kullanıldı
          ),
          title: Text(
            'dialog_add_asset_title'.tr(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'asset_name_label'.tr(),
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    hintText: 'asset_name_hint'.tr(),
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'amount_label'.tr(),
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    hintText: 'amount_hint'.tr(),
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _totalInvestedController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'total_invested_label'.tr(),
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    hintText: 'total_invested_hint'.tr(),
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
                  initialValue: _selectedUnitType,
                  dropdownColor: Colors.blueGrey.shade900,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'unit_type_label'.tr(),
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'piece', child: Text('unit_type_piece'.tr(), style: const TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'gram', child: Text('unit_type_gram'.tr(), style: const TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'lot', child: Text('unit_type_lot'.tr(), style: const TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'quarter', child: Text('unit_type_quarter'.tr(), style: const TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'half', child: Text('unit_type_half'.tr(), style: const TextStyle(color: Colors.white))),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _selectedUnitType = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearControllers();
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
                final name = _nameController.text.trim();
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                final totalInvested = double.tryParse(_totalInvestedController.text) ?? 0.0;

                if (name.isEmpty || amount <= 0 || totalInvested <= 0) return;

                // HATA DÜZELTİLDİ: Birim fiyatı dinamik olarak hesaplıyoruz
                final calculatedUnitPrice = totalInvested / amount;

                setState(() {
                  widget.wallet.assets.add(
                    Asset(
                      id: DateTime.now().toString(),
                      assetName: name,
                      amount: amount,
                      symbol: widget.wallet.currencySymbol, // HATA DÜZELTİLDİ: symbol cüzdandan aktarıldı
                      unitType: _selectedUnitType,
                      unitPrice: calculatedUnitPrice, // HATA DÜZELTİLDİ: unitPrice parametresi eklendi
                    ),
                  );
                });

                _clearControllers();
                Navigator.of(ctx).pop();
              },
              child: Text('button_add'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAsset(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)), // HATA DÜZELTİLDİ: border yerine side kullanıldı
        ),
        title: Text(
          'delete_asset_title'.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'delete_asset_message'.tr(args: [widget.wallet.assets[index].assetName]),
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
                widget.wallet.assets.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _amountController.clear();
    _totalInvestedController.clear();
    _selectedUnitType = 'piece';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _totalInvestedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.wallet.walletName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade900,
              Colors.blueGrey.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- TOP BAKIYE KARTI (Cam Efektli) ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'total_balance'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${_totalBalance.toStringAsFixed(2)} ${widget.wallet.currencySymbol == 'g' ? 'Gr' : widget.wallet.currencySymbol}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent.shade400,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- VARLIKLARIM BASLIGI ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.tealAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'my_assets_title'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // --- VARLIK LISTESI ---
              Expanded(
                child: widget.wallet.assets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_outlined,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_assets_yet'.tr(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: widget.wallet.assets.length,
                        itemBuilder: (context, index) {
                          final asset = widget.wallet.assets[index];

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                  title: Text(
                                    asset.assetName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      '${'unit_label'.tr()}: ${asset.amount} | ${'calculated_unit_price_label'.tr()}: ${asset.unitPrice.toStringAsFixed(2)} ${widget.wallet.currencySymbol}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // HATA DÜZELTİLDİ: asset.totalValue kullanıldı
                                      Text(
                                        '${asset.totalValue.toStringAsFixed(2)} ${widget.wallet.currencySymbol == 'g' ? 'Gr' : widget.wallet.currencySymbol}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.tealAccent.shade400,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                        onPressed: () => _confirmDeleteAsset(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssetDialog,
        backgroundColor: Colors.tealAccent.shade400,
        child: Icon(Icons.add, color: Colors.blueGrey.shade900),
      ),
    );
  }
}