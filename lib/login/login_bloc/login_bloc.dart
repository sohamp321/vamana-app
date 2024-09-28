import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import 'login_event.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(UserUnknown()) {
    on<CheckUser>(_checkUser);
    on<UserLoggedIn>(_isLoggedIn);
  }

  Future<void> _checkUser(CheckUser event, Emitter<LoginState> emit) async {
    emit(CheckingUser());
    final url = event.isLoggingIn
        ? '${dotenv.env["SERVER_URL"]}/login'
        : '${dotenv.env["SERVER_URL"]}/signup';

    try {
      final response = await _sendPostRequest(
        url: url,
        body: {"username": event.userName, "password": event.userPwd},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        dev.log("Response: ${response.body}");

        await _saveUserData(data["token"], data["username"]);
        emit(UserVerified(token: data["token"]));
      } else {
        // Extract error message from server response if available
        final errorData = jsonDecode(response.body);
        dev.log(errorData.toString());
        final errorMessage = errorData['remark'] ?? 'Unknown error occurred';
        dev.log("Error: $errorMessage");
        emit(LoginError(errorMessage));
      }
    } catch (e) {
      emit(LoginError('Login failed: $e'));
      dev.log("Error: $e");
    }
  }

  Future<void> _isLoggedIn(UserLoggedIn event, Emitter<LoginState> emit) async {
    emit(CheckingUser());

    try {
      final token = await _getUserToken();
      if (token != null) {
        emit(UserVerified(token: token));
      } else {
        emit(UserUnknown());
      }
    } catch (e) {
      emit(LoginError('Failed to retrieve user token: $e'));
      dev.log("Error: $e");
    }
  }

  Future<http.Response> _sendPostRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse(url);
    dev.log("Sending request to: $uri");

    return await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<void> _saveUserData(String token, String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
    await prefs.setString('userName', username);
    dev.log("Saved token: $token, username: $username");
  }

  Future<String?> _getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    dev.log('Saved User Token: $token');
    return token;
  }
}
