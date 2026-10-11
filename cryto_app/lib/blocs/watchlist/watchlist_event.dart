// lib/blocs/watchlist/watchlist_event.dart

abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {}

class AddToWatchlist extends WatchlistEvent {
  final String coinId;
  AddToWatchlist(this.coinId);
}

class RemoveFromWatchlist extends WatchlistEvent {
  final String coinId;
  RemoveFromWatchlist(this.coinId);
}
