// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive_and_api_for_class/core/network/local/hive_service.dart';
// import 'package:hive_and_api_for_class/features/batch/domain/entity/batch_entity.dart';
// import 'package:hive_and_api_for_class/features/batch/domain/use_case/batch_use_case.dart';
// import 'package:hive_and_api_for_class/features/batch/presentation/state/batch_state.dart';
// import 'package:hive_and_api_for_class/features/batch/presentation/viewmodel/batch_view_model.dart';
// import 'package:hive_and_api_for_class/features/course/domain/entity/course_entity.dart';
// import 'package:hive_and_api_for_class/features/course/domain/use_case/course_usecase.dart';
// import 'package:hive_and_api_for_class/features/course/presentation/state/course_state.dart';
// import 'package:hive_and_api_for_class/features/course/presentation/viewmodel/course_viewmodel.dart';
// import 'package:hive_and_api_for_class/features/home/presentation/view/bottom_view/dashboard_view.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import '../../../../../../build/unit_test_assets/test_data/course_entity_test.dart';
// import '../../../../../../test_data/batch_entity_test.dart';
// import 'dashboard_view_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<BatchUseCase>(),
//   MockSpec<CourseUseCase>(),
//   MockSpec<HiveService>(),
// ])
// void main() {
//   late MockHiveService hiveService;
//   late BatchUseCase batchUseCase;
//   late CourseUseCase courseUseCase;
//   late List<BatchEntity> batchList;
//   late List<CourseEntity> courseList;

//   setUp(() async {
//     batchUseCase = MockBatchUseCase();
//     courseUseCase = MockCourseUseCase();
//     // Load the data from JSON file
//     batchList = await getBatchListTest();
//     courseList = await getCourseListTest();

//     // Initialize Hive
//     hiveService = MockHiveService();
//     await hiveService.init();
//   });
//   testWidgets(
//     'dashboard view ...',
//     (tester) async {
//       final mockHiveService = Provider<HiveService>((ref) => hiveService);

//       final mockBatchViewModelProvider =
//           StateNotifierProvider<BatchViewModel, BatchState>(
//         (ref) => BatchViewModel(batchUseCase),
//       );

//       final mockCourseViewModelProvider =
//           StateNotifierProvider<CourseViewModel, CourseState>(
//         (ref) => CourseViewModel(courseUseCase),
//       );

//       when(batchUseCase.getAllBatches())
//           .thenAnswer((_) async => Right(batchList));

//       when(courseUseCase.getAllCourses())
//           .thenAnswer((_) async => Right(courseList));

//       await tester.pumpWidget(
//         ProviderScope(
//           overrides: [
//             batchViewModelProvider
//                 .overrideWithProvider(mockBatchViewModelProvider),
//             hiveServiceProvider.overrideWithProvider(mockHiveService),
//             courseViewModelProvider
//                 .overrideWithProvider(mockCourseViewModelProvider),
//           ],
//           child: const MaterialApp(
//             home: DashboardView(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();
//       expect(find.text('Dashboard View'), findsOneWidget);
//       expect(find.byType(Card), findsNWidgets(8));
//     },
//   );
// }
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_and_api_for_class/config/router/app_route.dart';
import 'package:hive_and_api_for_class/features/batch/domain/entity/batch_entity.dart';
import 'package:hive_and_api_for_class/features/batch/domain/use_case/batch_use_case.dart';
import 'package:hive_and_api_for_class/features/batch/presentation/state/batch_state.dart';
import 'package:hive_and_api_for_class/features/batch/presentation/viewmodel/batch_view_model.dart';
import 'package:hive_and_api_for_class/features/course/domain/entity/course_entity.dart';
import 'package:hive_and_api_for_class/features/course/domain/use_case/course_usecase.dart';
import 'package:hive_and_api_for_class/features/course/presentation/state/course_state.dart';
import 'package:hive_and_api_for_class/features/course/presentation/viewmodel/course_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../build/app/intermediates/assets/debug/flutter_assets/test_data/course_entity_test.dart';
import '../../../../../../test_data/batch_entity_test.dart';
import 'dashboard_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BatchUseCase>(),
  MockSpec<CourseUseCase>(),
])
void main() {
  late BatchUseCase mockBatchUsecase;
  late CourseUseCase mockCourseUsecase;
  late List<BatchEntity> batchEntity;
  late List<CourseEntity> courseEntity;

  setUp(() async {
    mockBatchUsecase = MockBatchUseCase();
    mockCourseUsecase = MockCourseUseCase();
    batchEntity = await getBatchListTest();
    courseEntity = await getCourseListTest();
  });
  testWidgets(
    'dashboard view ...',
    (tester) async {
      // Get the data from the test data not the actual api
      when(mockBatchUsecase.getAllBatches())
          .thenAnswer((_) async => Right(batchEntity));

      when(mockCourseUsecase.getAllCourses())
          .thenAnswer((_) async => Right(courseEntity));

      // Overriding the batchusecase from the mockbatchusecase
      final mockBatchViewModelProvider =
          StateNotifierProvider<BatchViewModel, BatchState>(
        (ref) => BatchViewModel(mockBatchUsecase),
      );

      final mockCourseViewModelProvider =
          StateNotifierProvider<CourseViewModel, CourseState>(
        (ref) => CourseViewModel(mockCourseUsecase),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            batchViewModelProvider
                .overrideWithProvider(mockBatchViewModelProvider),
            courseViewModelProvider
                .overrideWithProvider(mockCourseViewModelProvider),
          ],
          child: MaterialApp(
            routes: AppRoute.getApplicationRoute(),
            initialRoute: AppRoute.homeRoute,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // expect(find.text('Dashboard View'), findsOneWidget);

      expect(find.byType(GridView), findsNWidgets(1));
    },
  );
}
