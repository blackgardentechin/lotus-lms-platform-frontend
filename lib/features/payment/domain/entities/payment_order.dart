import 'package:equatable/equatable.dart';

/// Payment Order Entity
class PaymentOrder extends Equatable {
  final String id;
  final String currency;
  final int amount;
  final String? receipt;
  
  const PaymentOrder({
    required this.id,
    required this.currency,
    required this.amount,
    this.receipt,
  });
  
  @override
  List<Object?> get props => [id, currency, amount, receipt];
}
