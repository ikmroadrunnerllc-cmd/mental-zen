import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_zen/core/l10n/app_strings.dart';
import 'package:mental_zen/features/auth/domain/auth_repository.dart';
import 'package:mental_zen/features/auth/domain/auth_state.dart';
import 'package:mental_zen/features/auth/domain/user_entity.dart';
import 'package:mental_zen/main.dart';

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>.broadcast();
  UserEntity? _user;

  @override
  Stream<UserEntity?> get authStateChanges => _controller.stream;

  @override
  UserEntity? get currentUser => _user;

  @override
  Future<UserEntity> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    _user = UserEntity(uid: 'test_uid', email: email);
    _controller.add(_user);
    return _user!;
  }

  @override
  Future<UserEntity> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    _user = UserEntity(uid: 'test_uid', email: email);
    _controller.add(_user);
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}

void main() {
  testWidgets('App smoke test: renders SignInScreen on launch', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        child: const MentalZenApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.signIn), findsWidgets);
    expect(find.text(AppStrings.emailLabel), findsOneWidget);
    expect(find.text(AppStrings.passwordLabel), findsOneWidget);
  });
}
