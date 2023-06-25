import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_and_api_for_class/config/router/app_route.dart';
import 'package:hive_and_api_for_class/features/auth/domain/use_case/auth_usecase.dart';
import 'package:hive_and_api_for_class/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:hive_and_api_for_class/features/batch/domain/entity/batch_entity.dart';
import 'package:hive_and_api_for_class/features/batch/domain/use_case/batch_use_case.dart';
import 'package:hive_and_api_for_class/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:hive_and_api_for_class/features/course/domain/entity/course_entity.dart';
import 'package:hive_and_api_for_class/features/course/domain/use_case/course_usecase.dart';
import 'package:hive_and_api_for_class/features/course/presentation/viewmodel/course_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../build/unit_test_assets/test_data/course_entity_test.dart';
import '../../../../../test_data/batch_entity_test.dart';
import '../../../home/presentation/view/bottom_view/dashboard_view_test.mocks.dart';
import 'register_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
])
void main() {
  late AuthUseCase mockAuthUsecase;
  late BatchUseCase mockBatchUsecase;
  late CourseUseCase mockCourseUsecase;

  late List<BatchEntity> lstBatchEntity;
  late List<CourseEntity> lstCourseEntity;

  setUp(() async {
    mockAuthUsecase = MockAuthUseCase();
    mockBatchUsecase = MockBatchUseCase();
    mockCourseUsecase = MockCourseUseCase();

    lstBatchEntity = await getBatchListTest();
    lstCourseEntity = await getCourseListTest();
  });

  testWidgets('register view ...', (tester) async {
    when(mockBatchUsecase.getAllBatches())
        .thenAnswer((_) async => Right(lstBatchEntity));
    when(mockCourseUsecase.getAllCourses())
        .thenAnswer((_) async => Right(lstCourseEntity));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          batchViewModelProvider.overrideWith(
            (ref) => BatchViewModel(mockBatchUsecase),
          ),
          courseViewModelProvider.overrideWith(
            (ref) => CourseViewModel(mockCourseUsecase),
          ),
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(mockAuthUsecase),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.registerRoute,
          routes: AppRoute.getApplicationRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Center), findsOneWidget);

    // find the dropdown button
    // expect(find.byType(DropdownButtonFormField), findsOneWidget);
  });
}
