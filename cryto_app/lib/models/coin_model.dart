
class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double totalVolume;
  final double priceChangePercentage24h;
  final int marketCapRank;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.priceChangePercentage24h,
    required this.marketCapRank,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
    );
  }
}
