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
  final _symbolController = TextEditingController();
  final _amountController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAssets = List.from(widget.wallet.assets);
  }

  // Calculates the total balance of the wallet dynamically
  double get _totalBalance {
    return _currentAssets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  void _showAddAssetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('dialog_add_asset_title'.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _assetNameController,
                decoration: InputDecoration(labelText: 'asset_name_label'.tr(), hintText: 'asset_name_hint'.tr()),
              ),
              TextField(
                controller: _symbolController,
                decoration: InputDecoration(labelText: 'symbol_label'.tr(), hintText: 'symbol_hint'.tr()),
              ),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'amount_label'.tr(), hintText: 'amount_hint'.tr()),
              ),
              TextField(
                controller: _unitPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'unit_price_label'.tr(), hintText: 'unit_price_hint'.tr()),
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
              final sym = _symbolController.text.trim().toUpperCase();
              final amt = double.tryParse(_amountController.text.trim()) ?? 0.0;
              final price = double.tryParse(_unitPriceController.text.trim()) ?? 0.0;

              if (name.isEmpty || sym.isEmpty || amt <= 0 || price <= 0) return;

              setState(() {
                _currentAssets.add(
                  Asset(
                    id: DateTime.now().toString(),
                    assetName: name,
                    symbol: sym,
                    amount: amt,
                    unitPrice: price,
                  ),
                );
              });

              _clearControllers();
              Navigator.of(ctx).pop();
            },
            child: Text('button_add'.tr()),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _assetNameController.clear();
    _symbolController.clear();
    _amountController.clear();
    _unitPriceController.clear();
  }

  @override
  void dispose() {
    _assetNameController.dispose();
    _symbolController.dispose();
    _amountController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Total Balance Card (Row & Column Layout!)
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
                    '\$${_totalBalance.toStringAsFixed(2)}',
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
            // Assets List Title
            Text(
              'my_assets_title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Assets List Area
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
                              '${'unit_label'.tr()}: ${asset.amount} | \$${asset.unitPrice.toStringAsFixed(2)}',
                            ),
                            trailing: Text(
                              '\$${asset.totalValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssetDialog,
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(Icons.add_chart, color: Colors.white),
      ),
    );
  }
}