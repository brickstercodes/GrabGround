import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('${APIConstants.baseUrl}$endpoint');
    return await _client.get(uri);
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${APIConstants.baseUrl}$endpoint');
    return await _client.post(uri, body: body);
  }
}