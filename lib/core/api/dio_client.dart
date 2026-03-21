import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_interceptors.dart';

/// Dio HTTP Client Configuration
class DioClient {
  static Dio? _instance;
  
  static Dio get instance {
    if (_instance == null) {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? 
                      dotenv.env['REACT_APP_API_BASE_URL'] ?? 
                      'https://api.example.com';
      
      _instance = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      // Add interceptors
      _instance!.interceptors.add(AuthInterceptor());
      _instance!.interceptors.add(TenantInterceptor());
      
      // Add logger in debug mode
      _instance!.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
    
    return _instance!;
  }
  
  /// Reset instance (useful for testing or logout)
  static void reset() {
    _instance = null;
  }
}
