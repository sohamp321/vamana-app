import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  @override 
  List<Object> get props => [];
}

class CheckUser extends LoginEvent{
  final String userName ;
  final String userPwd;

  CheckUser(this.userName , this.userPwd);
  @override 
  List<Object> get props => [userName , userPwd];
}