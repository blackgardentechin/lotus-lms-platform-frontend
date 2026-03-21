import '../entities/payment_order.dart';

/// Payment Repository Interface
abstract class PaymentRepository {
  /// Create Razorpay order
  Future<PaymentOrder> createOrder({
    required String tenantId,
    required String courseId,
  });
  
  /// Update transaction status
  Future<void> updateTransaction({
    required String transactionId,
    required Map<String, dynamic> payload,
    required String tenantId,
  });
}
