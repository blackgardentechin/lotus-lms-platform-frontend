import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/order_model.dart';

/// Transaction Remote Data Source
class TransactionRemoteDataSource {
  final Dio _dio = DioClient.instance;
  
  /// Create Razorpay order
  Future<OrderModel> createOrder({
    required String tenantId,
    required String courseId,
  }) async {
    final response = await _dio.post(
      ApiConstants.createOrderEndpoint,
      data: {
        'tenant_id': tenantId,
        'course_id': courseId,
      },
    );
    
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }
  
  /// Update transaction status
  Future<void> updateTransaction({
    required String transactionId,
    required Map<String, dynamic> payload,
    required String tenantId,
  }) async {
    await _dio.put(
      '${ApiConstants.transactionsEndpoint}/$transactionId',
      data: payload,
      options: Options(
        headers: {
          'X-Tenant-Id': tenantId,
        },
      ),
    );
  }
}
