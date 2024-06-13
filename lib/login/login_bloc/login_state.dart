import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserUnknown extends LoginState {}

class CheckingUser extends LoginState {}

class UserVerified extends LoginState {
  final String token;

  UserVerified({required this.token});

  @override
  List<Object> get props => [token];
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
  @override
  List<Object> get props => [error];
}
