import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_and_api_for_class/config/router/app_route.dart';
import 'package:hive_and_api_for_class/features/auth/domain/use_case/auth_usecase.dart';
import 'package:hive_and_api_for_class/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
])
void main() {
  late AuthUseCase mockAuthUsecase;

  setUp(() async {
    mockAuthUsecase = MockAuthUseCase();
  });
  testWidgets(
    'login view ...',
    (tester) async {
      when(mockAuthUsecase.loginStudent('kiran', 'kiran123'))
          .thenAnswer((_) async => const Right(true));

      // final mockAuthViewModelProvider =
      //     StateNotifierProvider<AuthViewModel, AuthState>((ref) {
      //   return AuthViewModel(mockAuthUsecase);
      // });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider
                .overrideWith((ref) => AuthViewModel(mockAuthUsecase)),
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
