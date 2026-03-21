import '../../domain/repositories/payment_repository.dart';
import '../../domain/entities/payment_order.dart';
import '../datasources/transaction_remote_datasource.dart';

/// Payment Repository Implementation
class PaymentRepositoryImpl implements PaymentRepository {
  final TransactionRemoteDataSource _dataSource;
  
  PaymentRepositoryImpl({
    required TransactionRemoteDataSource dataSource,
  }) : _dataSource = dataSource;
  
  @override
  Future<PaymentOrder> createOrder({
    required String tenantId,
    required String courseId,
  }) async {
    final model = await _dataSource.createOrder(
      tenantId: tenantId,
      courseId: courseId,
    );
    return model.toEntity();
  }
  
  @override
  Future<void> updateTransaction({
    required String transactionId,
    required Map<String, dynamic> payload,
    required String tenantId,
  }) async {
    await _dataSource.updateTransaction(
      transactionId: transactionId,
      payload: payload,
      tenantId: tenantId,
    );
  }
}
