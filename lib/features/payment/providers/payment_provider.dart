import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/transaction_remote_datasource.dart';
import '../data/datasources/razorpay_datasource.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../domain/repositories/payment_repository.dart';
import '../domain/entities/payment_order.dart';

/// Transaction Data Source Provider
final transactionDataSourceProvider = Provider<TransactionRemoteDataSource>((ref) {
  return TransactionRemoteDataSource();
});

/// Razorpay Data Source Provider
final razorpayDataSourceProvider = Provider<RazorpayDataSource>((ref) {
  return RazorpayDataSource();
});

/// Payment Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    dataSource: ref.read(transactionDataSourceProvider),
  );
});

/// Create Order Provider
final createOrderProvider = FutureProvider.family<PaymentOrder, CreateOrderParams>(
  (ref, params) async {
    final repository = ref.read(paymentRepositoryProvider);
    return await repository.createOrder(
      tenantId: params.tenantId,
      courseId: params.courseId,
    );
  },
);

/// Create Order Parameters
class CreateOrderParams {
  final String tenantId;
  final String courseId;
  
  const CreateOrderParams({
    required this.tenantId,
    required this.courseId,
  });
}
