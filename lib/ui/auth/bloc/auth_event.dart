part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent{}

class AuthButtonClicked extends AuthEvent{
  final String  username;
  final String  password;

  AuthButtonClicked(this.username, this.password);
}

class AuthModeChangeClicked extends AuthEvent{}
