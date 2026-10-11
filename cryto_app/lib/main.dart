
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/coin_list/coin_list_bloc.dart';
import 'blocs/coin_detail/coin_detail_bloc.dart';
import 'blocs/watchlist/watchlist_bloc.dart';
import 'blocs/watchlist/watchlist_event.dart';
import 'screens/coin_list_screen.dart';
import 'screens/watchlist_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
     
      providers: [
        BlocProvider<CoinListBloc>(
          create: (_) => CoinListBloc(),
        ),
        BlocProvider<CoinDetailBloc>(
          create: (_) => CoinDetailBloc(),
        ),
        BlocProvider<WatchlistBloc>(
        
          create: (_) => WatchlistBloc()..add(LoadWatchlist()),
        ),
      ],
      child: MaterialApp(
        title: 'CryptoApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.cardBg,
          ),
     
          fontFamily: 'Roboto',
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.cardBg,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textHint,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

// Bottom nav to switch between Market and Watchlist tabs
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CoinListScreen(),
    WatchlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Watchlist',
            ),
          ],
        ),
      ),
    );
  }
}
