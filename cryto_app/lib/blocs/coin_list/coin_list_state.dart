// lib/blocs/coin_list/coin_list_state.dart
import '../../models/coin_model.dart';

abstract class CoinListState {}

// Just started, nothing loaded
class CoinListInitial extends CoinListState {}

// Loading first page
class CoinListLoading extends CoinListState {}

// Data loaded successfully
class CoinListLoaded extends CoinListState {
  final List<CoinModel> coins;
  final bool hasMore;
  final int currentPage;
  final String sortBy;

  CoinListLoaded({
    required this.coins,
    this.hasMore = true,
    this.currentPage = 1,
    this.sortBy = 'market_cap',
  });
}

// Loading next page (shows current coins + spinner at bottom)
class CoinListLoadingMore extends CoinListState {
  final List<CoinModel> coins;
  CoinListLoadingMore({required this.coins});
}

// Something went wrong
class CoinListError extends CoinListState {
  final String message;
  CoinListError(this.message);
}
