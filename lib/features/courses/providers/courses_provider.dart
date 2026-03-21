import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/course_remote_datasource.dart';
import '../data/repositories/course_repository_impl.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/entities/course.dart';

/// Course Remote Data Source Provider
final courseDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSource();
});

/// Course Repository Provider
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    dataSource: ref.read(courseDataSourceProvider),
  );
});

/// Courses Provider for a specific tenant
final coursesProvider = FutureProvider.family<List<Course>, String>((ref, tenantId) async {
  final repository = ref.read(courseRepositoryProvider);
  return await repository.fetchCourses(tenantId);
});

/// Course Detail Provider
final courseDetailProvider = FutureProvider.family<Course, CourseDetailParams>((ref, params) async {
  final repository = ref.read(courseRepositoryProvider);
  return await repository.fetchCourseDetail(params.courseId, params.tenantId);
});

/// Course Detail Parameters
class CourseDetailParams {
  final String courseId;
  final String tenantId;
  
  const CourseDetailParams({
    required this.courseId,
    required this.tenantId,
  });
}
