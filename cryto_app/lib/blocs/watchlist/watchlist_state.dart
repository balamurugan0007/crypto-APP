// lib/blocs/watchlist/watchlist_state.dart

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  // Just store coin IDs in the watchlist
  final List<String> coinIds;
  WatchlistLoaded(this.coinIds);

  bool contains(String coinId) => coinIds.contains(coinId);
}
