import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserUnknown extends LoginState {}

class CheckingUser extends LoginState {}

class UserVerified extends LoginState {}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
  @override
  List<Object> get props => [error];
}
