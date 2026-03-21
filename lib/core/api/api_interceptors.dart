import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

/// Auth Interceptor - Adds JWT token to requests
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get stored token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.idTokenKey);
    
    // Add authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
}

/// Tenant Interceptor - Adds tenant ID to requests
class TenantInterceptor extends Interceptor {
  String? _tenantId;
  
  /// Set tenant ID
  void setTenantId(String? tenantId) {
    _tenantId = tenantId;
  }
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Add tenant ID header if available
    if (_tenantId != null && _tenantId!.isNotEmpty) {
      options.headers[ApiConstants.tenantIdHeader] = _tenantId;
    }
    
    handler.next(options);
  }
}
