import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import 'login_event.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(UserUnknown()) {
    on<CheckUser>(_checkUser);
    on<UserLoggedIn>(_isLoggedIn);
  }

  void _checkUser(CheckUser event, Emitter<LoginState> emit) async {
    emit(CheckingUser());

    // await Future.delayed(const Duration(seconds: 2));

    // emit(UserVerified(token: "Token"));

    try {
      var url = Uri.parse('${dotenv.env["SERVER_URL"]}/login');
      dev.log("Sending request to : $url");
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({"username": event.userName, "password": event.userPwd}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        dev.log("Login Response: ${response.body}");

        dev.log("Saved Token: ${data["token"]}");

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('userToken', data["token"]);

        emit(UserVerified(token: data["token"]));
      } else {
        dev.log("Error Occured");
      }
    } catch (e) {
      emit(LoginError(e.toString()));
      dev.log("Login Error: $e");
    }

    // final supabase = Supabase.instance.client;

    // final response = await supabase.from("userInfo").select().eq("user_name", event.userName);
  }

  void _isLoggedIn(UserLoggedIn event, Emitter<LoginState> emit) async {
    emit(CheckingUser());

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('userToken');
    dev.log('Saved User Token : $token');

    if (token != null) {
      emit(UserVerified(token: token));
    } else {
      emit(UserUnknown());
    }
  }
}
