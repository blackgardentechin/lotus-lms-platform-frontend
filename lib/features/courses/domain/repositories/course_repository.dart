import '../entities/course.dart';

/// Course Repository Interface
abstract class CourseRepository {
  /// Fetch all courses for a tenant
  Future<List<Course>> fetchCourses(String tenantId);
  
  /// Fetch course detail
  Future<Course> fetchCourseDetail(String courseId, String tenantId);
}
