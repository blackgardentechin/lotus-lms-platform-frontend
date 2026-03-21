import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment_order.dart';

part 'order_model.g.dart';

/// Order Model from Razorpay
@JsonSerializable()
class OrderModel {
  final String id;
  final String currency;
  final int amount;
  final String? receipt;
  
  const OrderModel({
    required this.id,
    required this.currency,
    required this.amount,
    this.receipt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
  
  /// Convert to domain entity
  PaymentOrder toEntity() {
    return PaymentOrder(
      id: id,
      currency: currency,
      amount: amount,
      receipt: receipt,
    );
  }
}
