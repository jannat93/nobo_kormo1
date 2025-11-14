import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  /// --- GET JWT TOKEN ---
  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');  /// FIXED KEY
  }

  /// --- HEADERS ---
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final token = requiresAuth ? await _getToken() : null;

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// --- POST (JSON) ---
  Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse('$API_BASE_URL$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      return await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  /// --- PUT (JSON) ---
  Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    final url = Uri.parse('$API_BASE_URL$endpoint');
    final headers = await _getHeaders();

    try {
      return await http.put(
        url,
        headers: headers,
        body: json.encode(data),
      );
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  /// --- GET ---
  Future<http.Response> get(
      String endpoint, {
        Map<String, String>? queryParams,
      }) async {
    final uri = Uri.parse('$API_BASE_URL$endpoint')
        .replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    try {
      return await http.get(uri, headers: headers);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  /// --- MULTIPART PUT (Profile Picture Upload) ---
  Future<http.StreamedResponse> multipartPut(
      String endpoint,
      String fieldName,
      String filePath,
      Map<String, String> bodyFields,
      ) async {
    final url = Uri.parse('$API_BASE_URL$endpoint');
    final token = await _getToken();

    final request = http.MultipartRequest('PUT', url);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (File(filePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    }

    request.fields.addAll(bodyFields);

    try {
      return await request.send();
    } catch (e) {
      throw Exception('Multipart PUT failed: $e');
    }
  }

  /// --- MULTIPART POST ---
  Future<http.StreamedResponse> multipartPost(
      String endpoint,
      String fieldName,
      String? filePath,
      Map<String, String> bodyFields,
      ) async {
    final url = Uri.parse('$API_BASE_URL$endpoint');
    final token = await _getToken();

    final request = http.MultipartRequest('POST', url);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (filePath != null && File(filePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    }

    request.fields.addAll(bodyFields);

    try {
      return await request.send();
    } catch (e) {
      throw Exception('Multipart POST failed: $e');
    }
  }
}
