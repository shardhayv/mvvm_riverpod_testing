import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_and_api_for_class/config/constants/api_endpoint.dart';
import 'package:hive_and_api_for_class/core/failure/failure.dart';
import 'package:hive_and_api_for_class/core/network/remote/http_service.dart';
import 'package:hive_and_api_for_class/features/course/domain/entity/course_entity.dart';

final courseRemoteDataSourceProvider =
    Provider<CourseRemoteDataSource>(
  (ref) {
    return CourseRemoteDataSource(
      ref.read(httpServiceProvider),
    );
  },
);

class CourseRemoteDataSource {
  final Dio dio;

  CourseRemoteDataSource(this.dio);

  Future<Either<Failure, bool>> addCourse(CourseEntity course) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.createCourse,
        data: course.toJson(),
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    try {
      Response response = await dio.get(ApiEndpoints.getAllCourse);
      if (response.statusCode == 200) {
        List<CourseEntity> courses = [];
        response.data["data"].forEach((course) {
          courses.add(CourseEntity.fromJson(course));
        });
        return Right(courses);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
