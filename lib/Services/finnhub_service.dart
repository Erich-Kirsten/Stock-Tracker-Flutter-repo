import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_info.dart';
import '../utils/parse_utils.dart';

class FinnhubService {
  static const String _apiKey = '';
  static const String _baseUrl = 'https://finnhub.io/api/v1';

  static Future<StockInfo?> fetchStockQuote(String symbol, String name) async {
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null || data['c'] == null) {
          print('⚠️ 无效响应: $data');
          return null;
        }

        final double current = parseDouble(data['c']);
        final double previous = parseDouble(data['pc']);
        final double change = current - previous;
        final double percent = previous != 0 ? (change / previous) * 100 : 0.0;
        final bool isUp = change >= 0;

        return StockInfo(
          name: name,
          symbol: symbol,
          price: current,
          changeValue: change,
          changePercent: percent,
          isUp: isUp,
          low: parseDouble(data['l']),
          high: parseDouble(data['h']),
          volume: '-', // 该 API 无 volume 字段
        );
      } else {
        print('❌ 请求失败 (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ 网络错误: $e');
      return null;
    }
  }
}
