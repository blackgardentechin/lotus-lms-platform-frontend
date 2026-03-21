import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/course_model.dart';

/// Course Remote Data Source
class CourseRemoteDataSource {
  final Dio _dio = DioClient.instance;
  
  /// Fetch courses for a tenant
  Future<List<CourseModel>> fetchCourses(String tenantId) async {
    final response = await _dio.get(
      ApiConstants.coursesEndpoint,
      options: Options(
        headers: {
          ApiConstants.tenantIdHeader: tenantId,
        },
      ),
    );
    
    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    
    return items
        .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  
  /// Fetch course details
  Future<CourseModel> fetchCourseDetail(String courseId, String tenantId) async {
    final response = await _dio.get(
      '${ApiConstants.coursesEndpoint}/$courseId',
      options: Options(
        headers: {
          ApiConstants.tenantIdHeader: tenantId,
        },
      ),
    );
    
    return CourseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
