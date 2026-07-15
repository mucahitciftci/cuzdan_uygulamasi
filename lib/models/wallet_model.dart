import 'asset_model.dart';

class Wallet {
  final String id;
  final String walletName;
  final String currencySymbol; // Örn: '₺', '$', '€'
  final List<Asset> assets;

  Wallet({
    required this.id,
    required this.walletName,
    required this.currencySymbol, // Yeni alan
    required this.assets,
  });
}