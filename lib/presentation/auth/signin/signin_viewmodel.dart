import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';
import 'package:poster/presentation/auth/signin/signin_state.dart';
import 'package:poster/providers.dart';

class SigninViewModel extends Notifier<SigninState> {
  AuthUseCase get _useCase => ref.read(authUseCaseProvider);

String email = '';
String password = '';

  @override
  SigninState build() {
    return const SigninState();
  }

// viewからemailを受け取る
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }
// passwordを受け取る
  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  /// サインインを実行
  Future<void> signin(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _useCase.signIn(email, password);
      state = state.copyWith(
        isLoading: false,
        user: user,
        errorMessage: null,
        success: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        success: false,
      );
    }
  }
} 