class Asset {
  final String id;
  final String assetName; // e.g., Gram Gold, Bitcoin, US Dollar
  final String symbol;    // e.g., XAU, BTC, USD
  final double amount;    // Birim (Adet, Gram, Lot vb.)
  final double unitPrice; // Birim Fiyatı (Alış Fiyatı)

  Asset({
    required this.id,
    required this.assetName,
    required this.symbol,
    required this.amount,
    required this.unitPrice,
  });

  // Calculates the total value of this asset (Birim * Birim Fiyatı)
  double get totalValue => amount * unitPrice;
}