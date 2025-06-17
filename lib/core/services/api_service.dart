import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_cms_demo_app/core/config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Performs a GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.buildUrl(endpoint)).replace(
        queryParameters: queryParameters,
      );

      final response = await _client
          .get(uri, headers: {...ApiConfig.headers, ...?headers})
          .timeout(ApiConfig.timeout);

      return _handleResponse(response, fromJson: fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Failed to perform GET request: $e');
    }
  }

  /// Performs a POST request
  Future<T> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.buildUrl(endpoint));

      final response = await _client
          .post(
            uri,
            headers: {...ApiConfig.headers, ...?headers},
            body: json.encode(body),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response, fromJson: fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Failed to perform POST request: $e');
    }
  }

  /// Performs a PUT request
  Future<T> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.buildUrl(endpoint));

      final response = await _client
          .put(
            uri,
            headers: {...ApiConfig.headers, ...?headers},
            body: json.encode(body),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response, fromJson: fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Failed to perform PUT request: $e');
    }
  }

  /// Performs a DELETE request
  Future<T> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.buildUrl(endpoint));

      final response = await _client
          .delete(uri, headers: {...ApiConfig.headers, ...?headers})
          .timeout(ApiConfig.timeout);

      return _handleResponse(response, fromJson: fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Failed to perform DELETE request: $e');
    }
  }

  /// Handles the HTTP response and converts it to the desired type
  T _handleResponse<T>(
    http.Response response, {
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    try {
      final body = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (fromJson != null) {
          return fromJson(body);
        }
        return body as T;
      }

      throw ApiException(
        body['message'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
      );
    } on FormatException {
      throw ApiException('Invalid response format');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to process response: $e');
    }
  }

  /// Uploads a file to the specified endpoint
  Future<T> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.buildUrl(endpoint));
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({...ApiConfig.headers, ...?headers})
        ..files.add(await http.MultipartFile.fromPath('file', file.path))
        ..fields.addAll(fields ?? {});

      final streamedResponse = await request.send().timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, fromJson: fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('Failed to upload file: $e');
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
