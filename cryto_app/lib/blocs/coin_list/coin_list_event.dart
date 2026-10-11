// lib/blocs/coin_list/coin_list_event.dart

abstract class CoinListEvent {}

// Load first page
class LoadCoins extends CoinListEvent {}

// Load more coins (pagination)
class LoadMoreCoins extends CoinListEvent {}

// Sort coins
class SortCoins extends CoinListEvent {
  final String sortBy; // 'price', 'market_cap', 'change_24h', 'name'
  SortCoins(this.sortBy);
}
