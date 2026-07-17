import 'package:hive/hive.dart';

part 'asset_model.g.dart'; // Otomatik üretilecek dosya

@HiveType(typeId: 0) // Hive için benzersiz kimlik
class Asset extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String assetName;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String symbol;

  @HiveField(4)
  final String unitType;

  @HiveField(5)
  final double unitPrice;

  Asset({
    required this.id,
    required this.assetName,
    required this.amount,
    required this.symbol,
    required this.unitType,
    required this.unitPrice,
  });

  double get totalValue => amount * unitPrice;

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      assetName: json['assetName'] as String,
      amount: (json['amount'] as num).toDouble(),
      symbol: json['symbol'] as String,
      unitType: json['unitType'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetName': assetName,
      'amount': amount,
      'symbol': symbol,
      'unitType': unitType,
      'unitPrice': unitPrice,
    };
  }
}