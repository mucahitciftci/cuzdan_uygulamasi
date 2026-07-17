import 'package:hive/hive.dart';
import 'asset_model.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 1)
class Wallet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String walletName; // Güncellenebilir

  @HiveField(2)
  String currencySymbol; // Güncellenebilir

  @HiveField(3)
  final List<Asset> assets;

  Wallet({
    required this.id,
    required this.walletName,
    required this.currencySymbol,
    required this.assets,
  });
}