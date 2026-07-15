import 'asset_model.dart';

class Wallet {
  final String id;
  final String walletName;
  final List<Asset> assets; // List of assets belonging to this wallet

  Wallet({
    required this.id,
    required this.walletName,
    this.assets = const [], // Defaults to an empty list
  });
}