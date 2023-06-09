import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_and_api_for_class/core/failure/failure.dart';
import 'package:hive_and_api_for_class/core/network/local/hive_service.dart';
import 'package:hive_and_api_for_class/features/auth/data/model/auth_hive_model.dart';
import 'package:hive_and_api_for_class/features/auth/domain/entity/student_entity.dart';

final authLocalDataSourceProvider = Provider(
  (ref) => AuthLocalDataSource(
    ref.read(hiveServiceProvider),
    ref.read(authHiveModelProvider),
  ),
);

class AuthLocalDataSource {
  final HiveService _hiveService;
  final AuthHiveModel _authHiveModel;

  AuthLocalDataSource(this._hiveService, this._authHiveModel);

  Future<Either<Failure, bool>> registerStudent(StudentEntity student) async {
    try {
      await _hiveService.addStudent(_authHiveModel.toHiveModel(student));
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> loginStudent(
    String username,
    String password,
  ) async {
    try {
      final students = await _hiveService.getAllStudents();
      // use collection to check for username and password
      final isLogin = students.any(
        (element) =>
            element.username == username && element.password == password,
      );
      if (isLogin) {
        return const Right(true);
      } else {
        return Left(Failure(error: 'Username or password is wrong'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
