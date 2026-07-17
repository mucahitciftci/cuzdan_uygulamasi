import 'asset_model.dart';

class Wallet {
  final String id;
  final String walletName;
  final String currencySymbol;
  final List<Asset> assets;

  Wallet({
    required this.id,
    required this.walletName,
    required this.currencySymbol,
    required this.assets,
  });

  // JSON'dan nesneye dönüştürme
  factory Wallet.fromJson(Map<String, dynamic> json) {
    var assetList = json['assets'] as List;
    List<Asset> parsedAssets = assetList
        .map((assetJson) => Asset.fromJson(assetJson as Map<String, dynamic>))
        .toList();

    return Wallet(
      id: json['id'] as String,
      walletName: json['walletName'] as String,
      currencySymbol: json['currencySymbol'] as String,
      assets: parsedAssets,
    );
  }

  // Nesneden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletName': walletName,
      'currencySymbol': currencySymbol,
      'assets': assets.map((asset) => asset.toJson()).toList(),
    };
  }
}