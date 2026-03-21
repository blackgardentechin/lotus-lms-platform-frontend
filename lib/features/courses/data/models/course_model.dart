import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/course.dart';

part 'course_model.g.dart';

/// Course Model
@JsonSerializable()
class CourseModel {
  @JsonKey(name: 'course_id')
  final String courseId;
  
  final String title;
  final String description;
  final double price;
  final String currency;
  
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  const CourseModel({
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    this.imageUrl,
  });
  
  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
  
  /// Convert to domain entity
  Course toEntity() {
    return Course(
      courseId: courseId,
      title: title,
      description: description,
      price: price,
      currency: currency,
      imageUrl: imageUrl,
    );
  }
}
