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
  late List<Asset> _currentAssets;
  final _assetNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _totalInvestedController = TextEditingController();

  String _selectedUnitType = 'unit_type_gram';

  @override
  void initState() {
    super.initState();
    _currentAssets = List.from(widget.wallet.assets);
  }

  double get _totalBalance {
    return _currentAssets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  String get _currencySym {
    if (widget.wallet.currencySymbol == 'g') {
      return ' gr';
    }
    return widget.wallet.currencySymbol;
  }

  void _showAddAssetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('dialog_add_asset_title'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _assetNameController,
                  decoration: InputDecoration(
                    labelText: 'asset_name_label'.tr(), 
                    hintText: 'asset_name_hint'.tr()
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'amount_label'.tr(), 
                    hintText: 'amount_hint'.tr()
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedUnitType,
                  decoration: InputDecoration(
                    labelText: 'unit_type_label'.tr(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'unit_type_gram', child: Text('unit_type_gram'.tr())),
                    DropdownMenuItem(value: 'unit_type_piece', child: Text('unit_type_piece'.tr())),
                    DropdownMenuItem(value: 'unit_type_half', child: Text('unit_type_half'.tr())),
                    DropdownMenuItem(value: 'unit_type_quarter', child: Text('unit_type_quarter'.tr())),
                    DropdownMenuItem(value: 'unit_type_lot', child: Text('unit_type_lot'.tr())),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _selectedUnitType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _totalInvestedController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '${'total_invested_label'.tr()} ($_currencySym)', 
                    hintText: 'total_invested_hint'.tr()
                  ),
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
              child: Text('button_cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _assetNameController.text.trim();
                final amt = double.tryParse(_amountController.text.trim()) ?? 0.0;
                final totalInvested = double.tryParse(_totalInvestedController.text.trim()) ?? 0.0;

                if (name.isEmpty || amt <= 0 || totalInvested <= 0) return;

                final calculatedUnitPrice = totalInvested / amt;

                final generatedSymbol = name.length >= 2 
                    ? name.substring(0, 2).toUpperCase() 
                    : name.toUpperCase();

                setState(() {
                  _currentAssets.add(
                    Asset(
                      id: DateTime.now().toString(),
                      assetName: name,
                      symbol: generatedSymbol,
                      amount: amt,
                      unitType: _selectedUnitType.tr(),
                      unitPrice: calculatedUnitPrice,
                    ),
                  );
                });

                widget.wallet.assets.clear();
                widget.wallet.assets.addAll(_currentAssets);

                _clearControllers();
                Navigator.of(ctx).pop();
              },
              child: Text('button_add'.tr()),
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
        title: Text('delete_asset_title'.tr()),
        content: Text('delete_asset_message'.tr(args: [_currentAssets[index].assetName])),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('button_cancel'.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _currentAssets.removeAt(index);
              });
              widget.wallet.assets.clear();
              widget.wallet.assets.addAll(_currentAssets);
              
              Navigator.of(ctx).pop();
            },
            child: Text('button_delete'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _assetNameController.clear();
    _amountController.clear();
    _totalInvestedController.clear();
    _selectedUnitType = 'unit_type_gram';
  }

  @override
  void dispose() {
    _assetNameController.dispose();
    _amountController.dispose();
    _totalInvestedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGold = widget.wallet.currencySymbol == 'g';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallet.walletName),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'total_balance'.tr(),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isGold 
                        ? '${_totalBalance.toStringAsFixed(2)} gr'
                        : '$_currencySym${_totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'my_assets_title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _currentAssets.isEmpty
                  ? Center(
                      child: Text(
                        'no_assets_yet'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _currentAssets.length,
                      itemBuilder: (context, index) {
                        final asset = _currentAssets[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade100,
                              child: Text(
                                asset.symbol,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            title: Text(
                              asset.assetName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${'unit_label'.tr()}: ${asset.amount} ${asset.unitType}\n'
                              '${'calculated_unit_price_label'.tr()}: ${isGold ? "${asset.unitPrice.toStringAsFixed(2)} gr" : "$_currencySym${asset.unitPrice.toStringAsFixed(2)}"}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      isGold
                                          ? '${asset.totalValue.toStringAsFixed(2)} gr'
                                          : '$_currencySym${asset.totalValue.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => _confirmDeleteAsset(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssetDialog,
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(Icons.add_chart, color: Colors.white),
      ),
    );
  }
}