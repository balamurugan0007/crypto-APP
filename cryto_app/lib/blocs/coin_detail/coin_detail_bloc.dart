// lib/blocs/coin_detail/coin_detail_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'coin_detail_event.dart';
import 'coin_detail_state.dart';

class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  final ApiService _apiService = ApiService();

  CoinDetailBloc() : super(CoinDetailInitial()) {
    on<LoadCoinDetail>(_onLoadCoinDetail);
    on<LoadChart>(_onLoadChart);
  }

  Future<void> _onLoadCoinDetail(
      LoadCoinDetail event, Emitter<CoinDetailState> emit) async {
    emit(CoinDetailLoading());
    try {
     
      final coin = await _apiService.getCoinDetail(event.coinId);
      emit(CoinDetailLoaded(coin: coin, isChartLoading: true));

    
      final chartData = await _apiService.getCoinChart(event.coinId, 7);
      if (state is CoinDetailLoaded) {
        emit((state as CoinDetailLoaded).copyWith(
          chartData: chartData,
          isChartLoading: false,
        ));
      }
    } catch (e) {
      emit(CoinDetailError('Failed to load coin details.'));
    }
  }

  Future<void> _onLoadChart(
      LoadChart event, Emitter<CoinDetailState> emit) async {
    if (state is! CoinDetailLoaded) return;
    final currentState = state as CoinDetailLoaded;

    
    emit(currentState.copyWith(
      selectedDays: event.days,
      isChartLoading: true,
    ));

    try {
      final chartData =
          await _apiService.getCoinChart(event.coinId, event.days);
      emit(currentState.copyWith(
        chartData: chartData,
        selectedDays: event.days,
        isChartLoading: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isChartLoading: false));
    }
  }
}
