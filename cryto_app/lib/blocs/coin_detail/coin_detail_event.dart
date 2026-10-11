// lib/blocs/coin_detail/coin_detail_event.dart

abstract class CoinDetailEvent {}

class LoadCoinDetail extends CoinDetailEvent {
  final String coinId;
  LoadCoinDetail(this.coinId);
}

class LoadChart extends CoinDetailEvent {
  final String coinId;
  final int days;
  LoadChart(this.coinId, this.days);
}
