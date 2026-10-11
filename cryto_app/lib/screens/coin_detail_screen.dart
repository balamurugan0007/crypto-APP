// lib/screens/coin_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/coin_detail/coin_detail_bloc.dart';
import '../blocs/coin_detail/coin_detail_event.dart';
import '../blocs/coin_detail/coin_detail_state.dart';
import '../blocs/watchlist/watchlist_bloc.dart';
import '../blocs/watchlist/watchlist_event.dart';
import '../blocs/watchlist/watchlist_state.dart';
import '../utils/app_colors.dart';
import '../utils/format_helper.dart';
import '../widgets/price_chart_widget.dart';
import '../widgets/stat_card.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;
  final String coinName;

  const CoinDetailScreen({
    super.key,
    required this.coinId,
    required this.coinName,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoinDetailBloc>().add(LoadCoinDetail(widget.coinId));
  }

 
  final List<Map<String, dynamic>> _periods = [
    {'days': 1, 'label': '1D'},
    {'days': 7, 'label': '7D'},
    {'days': 30, 'label': '30D'},
    {'days': 90, 'label': '90D'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.coinName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
       
        actions: [
          BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, watchState) {
              final isInWatchlist = watchState is WatchlistLoaded &&
                  watchState.contains(widget.coinId);
              return IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.star : Icons.star_border,
                  color: isInWatchlist
                      ? const Color(0xFFFFD700)
                      : AppColors.textSecondary,
                ),
                onPressed: () {
                  if (isInWatchlist) {
                    context
                        .read<WatchlistBloc>()
                        .add(RemoveFromWatchlist(widget.coinId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Removed from watchlist'),
                          backgroundColor: AppColors.cardBg),
                    );
                  } else {
                    context
                        .read<WatchlistBloc>()
                        .add(AddToWatchlist(widget.coinId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Added to watchlist ⭐'),
                          backgroundColor: AppColors.cardBg),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinDetailBloc, CoinDetailState>(
        builder: (context, state) {
          if (state is CoinDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CoinDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.red, size: 60),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: () => context
                        .read<CoinDetailBloc>()
                        .add(LoadCoinDetail(widget.coinId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is! CoinDetailLoaded) return const SizedBox();

          final coin = state.coin;
          final isPositive = coin.priceChange24h >= 0;
          final changeColor = isPositive ? AppColors.green : AppColors.red;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: CachedNetworkImage(
                        imageUrl: coin.image,
                        width: 56,
                        height: 56,
                        placeholder: (context, url) => Container(
                          width: 56,
                          height: 56,
                          color: AppColors.border,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatPrice(coin.currentPrice),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: changeColor,
                            ),
                            Text(
                              formatPercent(coin.priceChange24h),
                              style: TextStyle(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              ' (24h)',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Rank badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${coin.marketCapRank}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

              
                Row(
                  children: _periods.map((p) {
                    final isSelected = p['days'] == state.selectedDays;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          context.read<CoinDetailBloc>().add(
                                LoadChart(widget.coinId, p['days'] as int),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            p['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Chart area
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: state.isChartLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )
                      : PriceChartWidget(
                          chartData: state.chartData,
                          isPositive: isPositive,
                        ),
                ),
                const SizedBox(height: 24),

                // Stats grid
                const Text(
                  'Market Stats',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    StatCard(
                        label: 'Market Cap',
                        value: formatLargeNumber(coin.marketCap)),
                    StatCard(
                        label: '24h Volume',
                        value: formatLargeNumber(coin.totalVolume)),
                    StatCard(
                        label: '24h High',
                        value: formatPrice(coin.high24h),
                        valueColor: AppColors.green),
                    StatCard(
                        label: '24h Low',
                        value: formatPrice(coin.low24h),
                        valueColor: AppColors.red),
                    StatCard(
                        label: 'All Time High',
                        value: formatPrice(coin.ath)),
                    StatCard(
                        label: 'All Time Low',
                        value: formatPrice(coin.atl)),
                    StatCard(
                        label: 'Circulating Supply',
                        value:
                            '${(coin.circulatingSupply / 1e6).toStringAsFixed(2)}M'),
                    StatCard(
                        label: '7d Change',
                        value: formatPercent(coin.priceChange7d),
                        valueColor: coin.priceChange7d >= 0
                            ? AppColors.green
                            : AppColors.red),
                  ],
                ),
                const SizedBox(height: 24),

                // About section
                if (coin.description.isNotEmpty) ...[
                  const Text(
                    'About',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                 
                    coin.description.length > 400
                        ? '${coin.description.substring(0, 400)}...'
                        : coin.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
