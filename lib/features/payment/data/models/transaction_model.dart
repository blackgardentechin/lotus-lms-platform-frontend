import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

/// Transaction Model
@JsonSerializable()
class TransactionModel {
  @JsonKey(name: 'razorpay_payment_id')
  final String razorpayPaymentId;
  
  @JsonKey(name: 'razorpay_order_id')
  final String razorpayOrderId;
  
  @JsonKey(name: 'razorpay_signature')
  final String? razorpaySignature;
  
  final String status;
  
  @JsonKey(name: 'course_id')
  final String courseId;
  
  final int amount;
  final String currency;
  
  @JsonKey(name: 'user_id')
  final String userId;
  
  final String? email;
  
  const TransactionModel({
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    this.razorpaySignature,
    required this.status,
    required this.courseId,
    required this.amount,
    required this.currency,
    required this.userId,
    this.email,
  });
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
