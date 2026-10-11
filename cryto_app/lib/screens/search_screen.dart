// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import 'coin_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/coin_detail/coin_detail_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  String _error = '';

  
  void _onSearchChanged(String query) {
    if (query.length < 2) {
      setState(() {
        _results = [];
        _error = '';
      });
      return;
    }
    _doSearch(query);
  }

  Future<void> _doSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final results = await _apiService.searchCoins(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Search failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Search coins...',
            hintStyle: TextStyle(color: AppColors.textHint),
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Text(_error,
            style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    if (_results.isEmpty && _searchController.text.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textHint),
            SizedBox(height: 12),
            Text(
              'Search for any cryptocurrency',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text('No coins found.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final coin = _results[index];
        return ListTile(
          leading: coin['thumb'] != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(coin['thumb']),
                  backgroundColor: AppColors.border,
                  radius: 20,
                )
              : const CircleAvatar(
                  backgroundColor: AppColors.border,
                  child: Icon(Icons.currency_bitcoin,
                      color: AppColors.textHint),
                ),
          title: Text(
            coin['name'] ?? '',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          subtitle: Text(
            (coin['symbol'] ?? '').toString().toUpperCase(),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.textSecondary),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => CoinDetailBloc(),
                  child: CoinDetailScreen(
                    coinId: coin['id'] ?? '',
                    coinName: coin['name'] ?? '',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
