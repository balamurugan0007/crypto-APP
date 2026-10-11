// lib/blocs/coin_list/coin_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/coin_model.dart';
import 'coin_list_event.dart';
import 'coin_list_state.dart';

class CoinListBloc extends Bloc<CoinListEvent, CoinListState> {
  final ApiService _apiService = ApiService();

  CoinListBloc() : super(CoinListInitial()) {
    on<LoadCoins>(_onLoadCoins);
    on<LoadMoreCoins>(_onLoadMoreCoins);
    on<SortCoins>(_onSortCoins);
  }


  Future<void> _onLoadCoins(
      LoadCoins event, Emitter<CoinListState> emit) async {
    emit(CoinListLoading());
    try {
      final coins = await _apiService.getCoins(page: 1);
      emit(CoinListLoaded(coins: coins, currentPage: 1));
    } catch (e) {
      emit(CoinListError('Failed to load coins. Please check your connection.'));
    }
  }

  
  Future<void> _onLoadMoreCoins(
      LoadMoreCoins event, Emitter<CoinListState> emit) async {

    if (state is! CoinListLoaded) return;
    final currentState = state as CoinListLoaded;

    emit(CoinListLoadingMore(coins: currentState.coins));

    try {
      final nextPage = currentState.currentPage + 1;
      final moreCoins = await _apiService.getCoins(page: nextPage);

      if (moreCoins.isEmpty) {
        emit(CoinListLoaded(
          coins: currentState.coins,
          hasMore: false,
          currentPage: currentState.currentPage,
          sortBy: currentState.sortBy,
        ));
      } else {
        final allCoins = [...currentState.coins, ...moreCoins];
        emit(CoinListLoaded(
          coins: allCoins,
          currentPage: nextPage,
          sortBy: currentState.sortBy,
        ));
      }
    } catch (e) {

      emit(CoinListLoaded(
        coins: currentState.coins,
        currentPage: currentState.currentPage,
      ));
    }
  }

  void _onSortCoins(SortCoins event, Emitter<CoinListState> emit) {
    if (state is! CoinListLoaded) return;
    final currentState = state as CoinListLoaded;

    List<CoinModel> sorted = List.from(currentState.coins);

    switch (event.sortBy) {
      case 'price':
        sorted.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case 'market_cap':
        sorted.sort((a, b) => b.marketCap.compareTo(a.marketCap));
        break;
      case 'change_24h':
        sorted.sort((a, b) => b.priceChangePercentage24h
            .compareTo(a.priceChangePercentage24h));
        break;
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    emit(CoinListLoaded(
      coins: sorted,
      currentPage: currentState.currentPage,
      hasMore: currentState.hasMore,
      sortBy: event.sortBy,
    ));
  }
}
