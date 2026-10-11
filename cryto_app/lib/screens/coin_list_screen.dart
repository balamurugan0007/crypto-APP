// lib/screens/coin_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/coin_list/coin_list_bloc.dart';
import '../blocs/coin_list/coin_list_event.dart';
import '../blocs/coin_list/coin_list_state.dart';
import '../utils/app_colors.dart';
import '../widgets/coin_list_tile.dart';
import 'coin_detail_screen.dart';
import 'search_screen.dart';

class CoinListScreen extends StatefulWidget {
  const CoinListScreen({super.key});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load coins when screen opens
    context.read<CoinListBloc>().add(LoadCoins());

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 200) {
        final state = context.read<CoinListBloc>().state;
        if (state is CoinListLoaded && state.hasMore) {
          context.read<CoinListBloc>().add(LoadMoreCoins());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final sortOptions = [
          ('market_cap', 'Market Cap'),
          ('price', 'Price'),
          ('change_24h', '24h Change'),
          ('name', 'Name (A-Z)'),
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...sortOptions.map((opt) => ListTile(
                    title: Text(opt.$2,
                        style:
                            const TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      context
                          .read<CoinListBloc>()
                          .add(SortCoins(opt.$1));
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          '📈 CryptoApp',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          // Sort button
          IconButton(
            icon: const Icon(Icons.sort, color: AppColors.textPrimary),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: BlocBuilder<CoinListBloc, CoinListState>(
        builder: (context, state) {
          if (state is CoinListLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CoinListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off,
                      color: AppColors.textSecondary, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style:
                        const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: () =>
                        context.read<CoinListBloc>().add(LoadCoins()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          List coins = [];
          bool isLoadingMore = false;

          if (state is CoinListLoaded) {
            coins = state.coins;
          } else if (state is CoinListLoadingMore) {
            coins = state.coins;
            isLoadingMore = true;
          }

          if (coins.isEmpty) {
            return const Center(
              child: Text('No coins found.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.cardBg,
            onRefresh: () async {
              context.read<CoinListBloc>().add(LoadCoins());
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: coins.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == coins.length) {
                  // Loading more spinner at bottom
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    ),
                  );
                }
                return CoinListTile(
                  coin: coins[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoinDetailScreen(
                          coinId: coins[index].id,
                          coinName: coins[index].name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
