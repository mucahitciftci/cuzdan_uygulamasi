import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/wallet_model.dart';
import '../models/asset_model.dart';
import '../theme/app_theme.dart';

class WalletDetailScreen extends StatefulWidget {
  final Wallet wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _totalInvestedController = TextEditingController();
  
  // --- HARDCODE ENGELLEMEK İÇİN STATİK SABİTLER ---
  static const String _boxWalletsName = 'wallets_box';
  static const String _currencyGold = 'g';
  static const String _textGoldGr = 'Gr';
  
  // Birim Tipleri Sabitleri
  static const String _unitPiece = 'piece';
  static const String _unitGram = 'gram';
  static const String _unitLot = 'lot';
  static const String _unitQuarter = 'quarter';
  static const String _unitHalf = 'half';

  String _selectedUnitType = _unitPiece;

  double get _totalBalance {
    double total = 0;
    for (var asset in widget.wallet.assets) {
      total += asset.totalValue; 
    }
    return total;
  }

  List<PieChartSectionData> _getChartSections(ThemeData theme, double total) {
    if (total == 0) return [];

    final List<Color> colors = [
      theme.primaryColor.withValues(alpha: 0.65),
      Colors.purpleAccent.withValues(alpha: 0.65),
      Colors.blueAccent.withValues(alpha: 0.65),
      Colors.orangeAccent.withValues(alpha: 0.65),
      Colors.pinkAccent.withValues(alpha: 0.65),
      Colors.amber.withValues(alpha: 0.65),
    ];

    return List.generate(widget.wallet.assets.length, (index) {
      final asset = widget.wallet.assets[index];
      final percentage = (asset.totalValue / total) * 100;
      final isDark = theme.brightness == Brightness.dark;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: asset.totalValue,
        title: '${asset.assetName}\n%${percentage.toStringAsFixed(1)}',
        radius: 75,
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
        borderSide: BorderSide(
          color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.15),
          width: 1.5,
        ),
      );
    });
  }

  void _showAddAssetDialog() {
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
            'dialog_add_asset_title'.tr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'asset_name_label'.tr(),
                    labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                    hintText: 'asset_name_hint'.tr(),
                    hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'amount_label'.tr(),
                    labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                    hintText: 'amount_hint'.tr(),
                    hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _totalInvestedController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'total_invested_label'.tr(),
                    labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                    hintText: 'total_invested_hint'.tr(),
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
                  initialValue: _selectedUnitType,
                  dropdownColor: dialogBg,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'unit_type_label'.tr(),
                    labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: _unitPiece, child: Text('unit_type_piece'.tr(), style: TextStyle(color: textColor))),
                    DropdownMenuItem(value: _unitGram, child: Text('unit_type_gram'.tr(), style: TextStyle(color: textColor))),
                    DropdownMenuItem(value: _unitLot, child: Text('unit_type_lot'.tr(), style: TextStyle(color: textColor))),
                    DropdownMenuItem(value: _unitQuarter, child: Text('unit_type_quarter'.tr(), style: TextStyle(color: textColor))),
                    DropdownMenuItem(value: _unitHalf, child: Text('unit_type_half'.tr(), style: TextStyle(color: textColor))),
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
              child: Text('button_cancel'.tr(), style: TextStyle(color: theme.primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: isDark ? Colors.blueGrey.shade900 : Colors.white,
              ),
              onPressed: () async {
                final name = _nameController.text.trim();
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                final totalInvested = double.tryParse(_totalInvestedController.text) ?? 0.0;

                if (name.isEmpty || amount <= 0 || totalInvested <= 0) return;

                final calculatedUnitPrice = totalInvested / amount;

                setState(() {
                  widget.wallet.assets.add(
                    Asset(
                      id: DateTime.now().toString(),
                      assetName: name,
                      amount: amount,
                      symbol: widget.wallet.currencySymbol,
                      unitType: _selectedUnitType,
                      unitPrice: calculatedUnitPrice,
                    ),
                  );
                });

                await widget.wallet.save();
                await Hive.box<Wallet>(_boxWalletsName).flush();

                _clearControllers();
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

  void _confirmDeleteAsset(int index) {
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
          'delete_asset_title'.tr(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'delete_asset_message'.tr(args: [widget.wallet.assets[index].assetName]),
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
              setState(() {
                widget.wallet.assets.removeAt(index);
              });

              await widget.wallet.save();
              await Hive.box<Wallet>(_boxWalletsName).flush();
              
              if (!context.mounted) return;
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _amountController.clear();
    _totalInvestedController.clear();
    _selectedUnitType = _unitPiece;
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = theme.primaryColor;
    final total = _totalBalance;

    final gradientColors = isDark
        ? [Colors.blueGrey.shade900, Colors.blueGrey.shade800, Colors.indigo.shade900]
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
                widget.wallet.walletName,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              backgroundColor: textColor.withValues(alpha: 0.05),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
                    setState(() {
                      if (context.locale == const Locale('tr')) {
                        context.setLocale(const Locale('en'));
                      } else {
                        context.setLocale(const Locale('tr'));
                      }
                    });
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: textColor.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'total_balance'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${total.toStringAsFixed(2)} ${widget.wallet.currencySymbol == _currencyGold ? _textGoldGr : widget.wallet.currencySymbol}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.wallet.assets.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 220,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: textColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 5,
                            centerSpaceRadius: 25,
                            sections: _getChartSections(theme, total),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'my_assets_title'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: widget.wallet.assets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_outlined,
                              size: 64,
                              color: textColor.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_assets_yet'.tr(),
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                  color: textColor.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: textColor.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                  title: Text(
                                    asset.assetName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      '${'unit_label'.tr()}: ${asset.amount} | ${'calculated_unit_price_label'.tr()}: ${asset.unitPrice.toStringAsFixed(2)} ${widget.wallet.currencySymbol}',
                                      style: TextStyle(
                                        color: textColor.withValues(alpha: 0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${asset.totalValue.toStringAsFixed(2)} ${widget.wallet.currencySymbol == _currencyGold ? _textGoldGr : widget.wallet.currencySymbol}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 22),
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
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: isDark ? Colors.blueGrey.shade900 : Colors.white),
      ),
    );
  }
}