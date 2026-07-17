class Asset {
  final String id;
  final String assetName;
  final double amount;
  final String symbol;
  final String unitType;
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

  // JSON'dan nesneye dönüştürme
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

  // Nesneden JSON'a dönüştürme
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