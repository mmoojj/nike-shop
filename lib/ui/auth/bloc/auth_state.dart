part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState(this.isLoginMode);
  final bool isLoginMode;
  
  @override
  List<Object> get props => [isLoginMode];
}

final class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
}

class AuthError extends AuthState{
  final AppException exception;
  const AuthError(super.isLoginMode, this.exception);
}

class AuthSuccess extends AuthState{
  const AuthSuccess(super.isLoginMode);
}

class AuthLoading extends AuthState{
  const AuthLoading(super.isLoginMode);
}
