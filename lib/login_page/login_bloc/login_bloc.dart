import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_state.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(UserUnknown()) {
    on<CheckUser>(_checkUser);
  }
  void _checkUser(CheckUser event, Emitter<LoginState> emit) async {
    emit(CheckingUser());
    final supabase = Supabase.instance.client;

    final response = await supabase.from("userInfo").select().eq("user_name", event.userName);
  }
}
