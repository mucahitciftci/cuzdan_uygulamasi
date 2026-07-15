class Asset {
  final String id;
  final String assetName; 
  final String symbol;    
  final double amount;    // Sayısal miktar (örn: 10 ya da 0.5)
  final String unitType;  // Birim türü (örn: Gram, Çeyrek, Adet)
  final double unitPrice; 

  Asset({
    required this.id,
    required this.assetName,
    required this.symbol,
    required this.amount,
    required this.unitType, // Yeni alan
    required this.unitPrice,
  });

  double get totalValue => amount * unitPrice;
}