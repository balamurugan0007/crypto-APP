
class CoinDetailModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final String description;
  final double currentPrice;
  final double marketCap;
  final double totalVolume;
  final double priceChange24h;
  final double priceChange7d;
  final double priceChange30d;
  final double high24h;
  final double low24h;
  final double circulatingSupply;
  final double? totalSupply;
  final int marketCapRank;
  final double ath;
  final double atl;

  CoinDetailModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.description,
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.priceChange24h,
    required this.priceChange7d,
    required this.priceChange30d,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
    this.totalSupply,
    required this.marketCapRank,
    required this.ath,
    required this.atl,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    return CoinDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChange7d: (json['price_change_7d'] ?? 0).toDouble(),
      priceChange30d: (json['price_change_30d'] ?? 0).toDouble(),
      high24h: (json['high_24h'] ?? 0).toDouble(),
      low24h: (json['low_24h'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      totalSupply: json['total_supply'] != null
          ? (json['total_supply']).toDouble()
          : null,
      marketCapRank: json['market_cap_rank'] ?? 0,
      ath: (json['ath'] ?? 0).toDouble(),
      atl: (json['atl'] ?? 0).toDouble(),
    );
  }
}
