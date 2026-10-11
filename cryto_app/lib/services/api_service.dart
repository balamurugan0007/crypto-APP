// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';
import '../models/coin_detail_model.dart';

class ApiService {

  static const String baseUrl = 'http://10.102.41.170:8000';

  static const Duration _timeout = Duration(seconds: 15);

  Future<List<CoinModel>> getCoins({int page = 1}) async {
    final url = Uri.parse('$baseUrl/coins?page=$page&per_page=20');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => CoinModel.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Cannot connect to backend.\nMake sure backend is running and phone is on same WiFi.');
    } on TimeoutException {
      throw Exception('Request timed out. Backend might be slow.');
    } catch (e) {
      throw Exception('Failed to load coins: $e');
    }
  }

  Future<CoinDetailModel> getCoinDetail(String coinId) async {
    final url = Uri.parse('$baseUrl/coins/$coinId');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CoinDetailModel.fromJson(data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Cannot connect to backend.');
    } on TimeoutException {
      throw Exception('Request timed out.');
    } catch (e) {
      throw Exception('Failed to load coin detail: $e');
    }
  }


  Future<List<List<dynamic>>> getCoinChart(String coinId, int days) async {
    final url = Uri.parse('$baseUrl/coins/$coinId/chart?days=$days');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List prices = data['prices'];
        return prices.map((p) => p as List<dynamic>).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Cannot connect to backend.');
    } on TimeoutException {
      throw Exception('Chart request timed out.');
    } catch (e) {
      throw Exception('Failed to load chart: $e');
    }
  }


  Future<List<Map<String, dynamic>>> searchCoins(String query) async {
    final url =
        Uri.parse('$baseUrl/search?query=${Uri.encodeComponent(query)}');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coins = data['coins'];
        return coins.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Cannot connect to backend.');
    } on TimeoutException {
      throw Exception('Search timed out.');
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }


  Future<Map<String, dynamic>> getGlobalStats() async {
    final url = Uri.parse('$baseUrl/global');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load global stats: $e');
    }
  }
}
