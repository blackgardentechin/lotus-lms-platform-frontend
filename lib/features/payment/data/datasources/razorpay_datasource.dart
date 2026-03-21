import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/order_model.dart';

/// Razorpay Data Source for payment integration
class RazorpayDataSource {
  late Razorpay _razorpay;
  
  RazorpayDataSource() {
    _razorpay = Razorpay();
  }
  
  /// Open Razorpay checkout
  void openCheckout({
    required OrderModel order,
    required String courseName,
    required String userName,
    required String userEmail,
    required String courseId,
    required String tenantId,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function() onDismiss,
  }) {
    final options = {
      'key': AppConstants.razorpayKeyId,
      'amount': order.amount,
      'currency': order.currency,
      'name': 'Lotus LMS',
      'description': courseName,
      'order_id': order.id,
      'prefill': {
        'name': userName,
        'email': userEmail,
      },
      'notes': {
        'course_id': courseId,
        'tenant_id': tenantId,
      },
      'theme': {
        'color': '#0077b6',
      },
    };
    
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      onSuccess(response as PaymentSuccessResponse);
    });
    
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      onFailure(response as PaymentFailureResponse);
    });
    
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      // Handle external wallet if needed
    });
    
    try {
      _razorpay.open(options);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
  
  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}
