import 'package:equatable/equatable.dart';

/// Course Entity
class Course extends Equatable {
  final String courseId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String? imageUrl;
  
  const Course({
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    this.imageUrl,
  });
  
  bool get isFree => price == 0;
  
  @override
  List<Object?> get props => [courseId, title, description, price, currency, imageUrl];
}
