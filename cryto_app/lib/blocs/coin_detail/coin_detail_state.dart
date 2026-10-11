// lib/blocs/coin_detail/coin_detail_state.dart
import '../../models/coin_detail_model.dart';

abstract class CoinDetailState {}

class CoinDetailInitial extends CoinDetailState {}

class CoinDetailLoading extends CoinDetailState {}

class CoinDetailLoaded extends CoinDetailState {
  final CoinDetailModel coin;
  final List<List<dynamic>> chartData;
  final int selectedDays;
  final bool isChartLoading;

  CoinDetailLoaded({
    required this.coin,
    this.chartData = const [],
    this.selectedDays = 7,
    this.isChartLoading = false,
  });


  CoinDetailLoaded copyWith({
    CoinDetailModel? coin,
    List<List<dynamic>>? chartData,
    int? selectedDays,
    bool? isChartLoading,
  }) {
    return CoinDetailLoaded(
      coin: coin ?? this.coin,
      chartData: chartData ?? this.chartData,
      selectedDays: selectedDays ?? this.selectedDays,
      isChartLoading: isChartLoading ?? this.isChartLoading,
    );
  }
}

class CoinDetailError extends CoinDetailState {
  final String message;
  CoinDetailError(this.message);
}
