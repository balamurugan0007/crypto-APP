// lib/blocs/watchlist/watchlist_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {

  static const String _prefKey = 'watchlist_coins';

  WatchlistBloc() : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoad);
    on<AddToWatchlist>(_onAdd);
    on<RemoveFromWatchlist>(_onRemove);
  }

  Future<void> _onLoad(
      LoadWatchlist event, Emitter<WatchlistState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_prefKey) ?? [];
    emit(WatchlistLoaded(ids));
  }

  Future<void> _onAdd(
      AddToWatchlist event, Emitter<WatchlistState> emit) async {
    final currentIds = _getCurrentIds();
    if (!currentIds.contains(event.coinId)) {
      final newIds = [...currentIds, event.coinId];
      await _saveToPrefs(newIds);
      emit(WatchlistLoaded(newIds));
    }
  }

  Future<void> _onRemove(
      RemoveFromWatchlist event, Emitter<WatchlistState> emit) async {
    final currentIds = _getCurrentIds();
    final newIds = currentIds.where((id) => id != event.coinId).toList();
    await _saveToPrefs(newIds);
    emit(WatchlistLoaded(newIds));
  }

  List<String> _getCurrentIds() {
    if (state is WatchlistLoaded) {
      return (state as WatchlistLoaded).coinIds;
    }
    return [];
  }

  Future<void> _saveToPrefs(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, ids);
  }
}
