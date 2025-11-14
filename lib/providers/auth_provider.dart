import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; // Needed for StreamedResponse handling

import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkLoginStatus();
  }

  /// Check login status on app start
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await _storage.read(key: 'jwt_token');
    print('🔑 Stored Token: $token');

    if (token != null) {
      try {
        final response = await _api.get('/users/profile');
        print('👤 Profile Response: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body)['data'];
          _user = User.fromJson(data);
          _isAuthenticated = true;
        } else {
          await logout();
        }
      } on SocketException {
        // If offline but token exists, assume still logged in
        _isAuthenticated = true;
      } catch (e) {
        print('❌ Error fetching profile: $e');
        await logout();
      }
    } else {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Register new user
  Future<bool> register(String fullName, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.post(
        '/auth/register',
        {
          'full_name': fullName,
          'email': email,
          'password': password,
          'experience_level': 'Fresher',
        },
        requiresAuth: false,
      );

      _isLoading = false;

      if (response.statusCode == 201) {
        return await login(email, password);
      } else {
        _error = json.decode(response.body)['message'] ??
            'Registration failed with status ${response.statusCode}.';
        notifyListeners();
        return false;
      }
    } on SocketException {
      _error = 'Connection failed. Please check your internet connection.';
    } catch (e) {
      _error = 'An unexpected error occurred during registration.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final token = data['token'];
        print('✅ Login Token: $token');

        // Save token securely
        await _storage.write(key: 'jwt_token', value: token);

        _user = User.fromJson(data['user']);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = json.decode(response.body)['message'] ??
            'Invalid credentials. Please try again.';
      }
    } on SocketException {
      _error = 'Connection failed. Please check your internet connection.';
    } catch (e) {
      _error = 'An unexpected error occurred during login.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Update profile with or without image
  Future<bool> updateProfile(Map<String, String> data, {String? filePath}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    int statusCode = 500;
    String responseBody = '';

    try {
      if (filePath != null) {
        // Multipart request (with file)
        final streamedResponse =
        await _api.multipartPut('/users/profile', 'profile_picture', filePath, data);
        statusCode = streamedResponse.statusCode;

        // CRITICAL FIX: Read the stream response body
        responseBody = await streamedResponse.stream.bytesToString();
      } else {
        // Standard JSON PUT request
        final response = await _api.put('/users/profile', data);
        statusCode = response.statusCode;
        responseBody = response.body;
      }

      // --- Centralized Success Handling ---

      if (statusCode == 200) {
        final responseData = json.decode(responseBody);

        // FIX: Update local user state immediately with the new data from the server
        _user = User.fromJson(responseData['data']);

        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        // Handle server-side errors
        final errorMsg = json.decode(responseBody)['message'] ?? 'Update failed.';
        _error = 'Update failed: $errorMsg';
      }
    } on SocketException {
      _error = 'Connection failed. Please check your internet connection.';
    } catch (e) {
      _error = 'Update failed due to network or client error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}










// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../models/user_model.dart';
// import '../services/api_service.dart';
//
// class AuthProvider with ChangeNotifier {
//   final ApiService _api = ApiService();
//   final _storage = const FlutterSecureStorage();
//   User? _user;
//   bool _isAuthenticated = false;
//   bool _isLoading = true;
//   String? _error;
//
//   User? get user => _user;
//   bool get isAuthenticated => _isAuthenticated;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   AuthProvider() {
//     _checkLoginStatus();
//   }
//
//   /// Check login status on app start
//   Future<void> _checkLoginStatus() async {
//     _isLoading = true;
//     notifyListeners();
//
//     final token = await _storage.read(key: 'jwt_token');
//     print('🔑 Stored Token: $token');
//
//     if (token != null) {
//       try {
//         final response = await _api.get('/users/profile');
//         print('👤 Profile Response: ${response.statusCode}');
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body)['data'];
//           _user = User.fromJson(data);
//           _isAuthenticated = true;
//         } else {
//           await logout();
//         }
//       } on SocketException {
//         // If offline but token exists, assume still logged in
//         _isAuthenticated = true;
//       } catch (e) {
//         print('❌ Error fetching profile: $e');
//         await logout();
//       }
//     } else {
//       _isAuthenticated = false;
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Register new user
//   Future<bool> register(String fullName, String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await _api.post(
//         '/auth/register',
//         {
//           'full_name': fullName,
//           'email': email,
//           'password': password,
//           'experience_level': 'Fresher',
//         },
//         requiresAuth: false,
//       );
//
//       _isLoading = false;
//
//       if (response.statusCode == 201) {
//         return await login(email, password);
//       } else {
//         _error = json.decode(response.body)['message'] ??
//             'Registration failed with status ${response.statusCode}.';
//         notifyListeners();
//         return false;
//       }
//     } on SocketException {
//       _error = 'Connection failed. Please check your internet connection.';
//     } catch (e) {
//       _error = 'An unexpected error occurred during registration.';
//     }
//
//     _isLoading = false;
//     notifyListeners();
//     return false;
//   }
//
//   /// Login user
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await _api.post(
//         '/auth/login',
//         {
//           'email': email,
//           'password': password,
//         },
//         requiresAuth: false,
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body)['data'];
//         final token = data['token'];
//         print('✅ Login Token: $token');
//
//         // Save token securely
//         await _storage.write(key: 'jwt_token', value: token);
//
//         _user = User.fromJson(data['user']);
//         _isAuthenticated = true;
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = json.decode(response.body)['message'] ??
//             'Invalid credentials. Please try again.';
//       }
//     } on SocketException {
//       _error = 'Connection failed. Please check your internet connection.';
//     } catch (e) {
//       _error = 'An unexpected error occurred during login.';
//     }
//
//     _isLoading = false;
//     notifyListeners();
//     return false;
//   }
//
//   /// Logout user
//   Future<void> logout() async {
//     await _storage.delete(key: 'jwt_token');
//     _user = null;
//     _isAuthenticated = false;
//     notifyListeners();
//   }
//
//   /// Update profile with or without image
//   Future<bool> updateProfile(Map<String, String> data, {String? filePath}) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     int statusCode = 500;
//     String responseBody = '';
//
//     try {
//       if (filePath != null) {
//         // Multipart request (with file)
//         final streamedResponse =
//         await _api.multipartPut('/users/profile', 'profile_picture', filePath, data);
//         statusCode = streamedResponse.statusCode;
//
//         // CRITICAL FIX: Read the stream response body
//         responseBody = await streamedResponse.stream.bytesToString();
//       } else {
//         // Standard JSON PUT request
//         final response = await _api.put('/users/profile', data);
//         statusCode = response.statusCode;
//         responseBody = response.body;
//       }
//
//       // --- Centralized Success Handling ---
//
//       if (statusCode == 200) {
//         final responseData = json.decode(responseBody);
//
//         // FIX: Update local user state immediately with the new data from the server
//         _user = User.fromJson(responseData['data']);
//
//         _isLoading = false;
//         notifyListeners();
//
//         return true;
//       } else {
//         // Handle server-side errors (validation, database failure, etc.)
//         final errorMsg = json.decode(responseBody)['message'] ?? 'Update failed.';
//         _error = 'Update failed: $errorMsg';
//       }
//     } on SocketException {
//       _error = 'Connection failed. Please check your internet connection.';
//     } catch (e) {
//       _error = 'Update failed due to network or client error: $e';
//     }
//
//     _isLoading = false;
//     notifyListeners();
//     return false;
//   }
// }