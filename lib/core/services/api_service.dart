import 'package:dio/dio.dart';
import 'package:flight_delay_predict/core/services/storage_service.dart';

class ApiService {
  ApiService(this._storageService)
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 8),
            receiveTimeout: const Duration(seconds: 8),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  final StorageService _storageService;
  final Dio _dio;

  // Get base URL dynamically from storage
  String get _baseUrl => _storageService.getBaseUrl();

  // Test Connection
  Future<bool> checkHealth() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('$_baseUrl/api/health');
      if (response.statusCode == 200) {
        final data = response.data;
        return data?['status'] == 'healthy' || data?['status'] == 'success';
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  // Prediction request
  Future<Map<String, dynamic>> predict(Map<String, dynamic> requestData) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/api/predict',
        data: requestData,
      );
      
      if (response.statusCode == 200) {
        return response.data!;
      } else {
        throw _handleResponseError(response);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on Exception catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Handle non-200 responses
  Exception _handleResponseError(Response<dynamic> response) {
    final data = response.data;
    if (data is Map) {
      if (data.containsKey('error')) {
        return Exception(data['error'].toString());
      }
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is List) {
          // Parse FastAPI pydantic validation errors
          final messages = detail.map((e) {
            if (e is Map && e.containsKey('msg')) {
              final loc = e['loc'] is List ? (e['loc'] as List).last : '';
              return '$loc: ${e['msg']}';
            }
            return e.toString();
          }).join(', ');
          return Exception('Validation Error: $messages');
        }
        return Exception(detail.toString());
      }
    }
    return Exception('Server returned code ${response.statusCode}');
  }

  // Handle network / Dio specific errors
  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Unable to connect to server. Connection timed out.');
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        'Unable to connect to server. Please check your network and API host address.',
      );
    }

    final response = e.response;
    if (response != null) {
      if (response.statusCode == 500) {
        return Exception('Internal server error.');
      }
      if (response.statusCode == 422) {
        return _handleResponseError(response);
      }
      try {
        return _handleResponseError(response);
      } on Exception catch (_) {
        return Exception('Server Error: ${response.statusCode}');
      }
    }

    return Exception(
      'Network connection error: ${e.message ?? 'Unknown issue'}',
    );
  }
}
