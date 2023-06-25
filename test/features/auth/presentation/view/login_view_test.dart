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

import '../../../../../build/unit_test_assets/test_data/batch_entity_test.dart';
import '../../../../../build/unit_test_assets/test_data/course_entity_test.dart';
import '../../../home/presentation/view/bottom_view/dashboard_view_test.mocks.dart';
import 'register_view_test.mocks.dart';

@GenerateNiceMocks([])
void main() {
  late AuthUseCase mockAuthUsecase;
  late BatchUseCase mockBatchUsecase;
  late CourseUseCase mockCourseUsecase;
  // We are doning these for dashboard
  late List<BatchEntity> lstBatchEntity;
  late List<CourseEntity> lstCourseEntity;

  late bool isLogin;
  setUp(() async {
    // Because these mocks are already created in the register_view_test.dart file
    mockAuthUsecase = MockAuthUseCase();
    mockBatchUsecase = MockBatchUseCase();
    mockCourseUsecase = MockCourseUseCase();
    lstBatchEntity = await getBatchListTest();
    lstCourseEntity = await getCourseListTest();

    isLogin = true;
  });
  testWidgets(
    'login view ...',
    (tester) async {
      when(mockAuthUsecase.loginStudent('kiran', 'kiran123'))
          .thenAnswer((_) async => Right(isLogin));

      when(mockBatchUsecase.getAllBatches())
          .thenAnswer((_) async => Right(lstBatchEntity));

      when(mockCourseUsecase.getAllCourses())
          .thenAnswer((_) async => Right(lstCourseEntity));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider
                .overrideWith((ref) => AuthViewModel(mockAuthUsecase)),
            batchViewModelProvider
                .overrideWith((ref) => BatchViewModel(mockBatchUsecase)),
            courseViewModelProvider
                .overrideWith((ref) => CourseViewModel(mockCourseUsecase)),
          ],
          child: MaterialApp(
            initialRoute: AppRoute.loginRoute,
            routes: AppRoute.getApplicationRoute(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Type in first textformfield
      await tester.enterText(find.byType(TextField).first, 'kiran');
      // Type in second textformfield
      await tester.enterText(find.byType(TextField).last, 'kiran123');

      // Tap on login button
      //await tester.tap(find.byType(ElevatedButton).first);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));

      await tester.pumpAndSettle();
      // expect(find.byType(TextField), findsNWidgets(2));
      // expect(find.byType(ElevatedButton), findsNWidgets(2));

      expect(find.text('Dashboard View'), findsOneWidget);
    },
  );
}
