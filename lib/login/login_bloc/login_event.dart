import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUser extends LoginEvent {
  final String userName;
  final String userPwd;

  CheckUser({required this.userName, required this.userPwd});
  @override
  List<Object> get props => [userName, userPwd];
}

class UserLoggedIn extends LoginEvent {
}
