import 'package:hive/hive.dart';
import 'asset_model.dart';

part 'wallet_model.g.dart'; // Otomatik üretilecek dosya

@HiveType(typeId: 1) // Hive için benzersiz kimlik
class Wallet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String walletName;

  @HiveField(2)
  final String currencySymbol;

  @HiveField(3)
  final List<Asset> assets; // Hive iç içe listeleri destekler

  Wallet({
    required this.id,
    required this.walletName,
    required this.currencySymbol,
    required this.assets,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletName': walletName,
      'currencySymbol': currencySymbol,
      'assets': assets.map((asset) => asset.toJson()).toList(),
    };
  }
}