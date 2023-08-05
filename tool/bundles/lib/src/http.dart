import 'package:http/http.dart' as http;

Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
  return http.get(url, headers: headers);
}
