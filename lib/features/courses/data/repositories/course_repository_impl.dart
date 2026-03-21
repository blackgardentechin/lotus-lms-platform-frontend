import '../../domain/repositories/course_repository.dart';
import '../../domain/entities/course.dart';
import '../datasources/course_remote_datasource.dart';

/// Course Repository Implementation
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _dataSource;
  
  CourseRepositoryImpl({
    required CourseRemoteDataSource dataSource,
  }) : _dataSource = dataSource;
  
  @override
  Future<List<Course>> fetchCourses(String tenantId) async {
    final models = await _dataSource.fetchCourses(tenantId);
    return models.map((model) => model.toEntity()).toList();
  }
  
  @override
  Future<Course> fetchCourseDetail(String courseId, String tenantId) async {
    final model = await _dataSource.fetchCourseDetail(courseId, tenantId);
    return model.toEntity();
  }
}
