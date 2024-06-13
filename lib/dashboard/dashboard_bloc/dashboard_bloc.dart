import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitial()) {
    on<GetDashBoardData>(_getDashBoardData);
  }

  void _getDashBoardData(
      GetDashBoardData event, Emitter<DashBoardState> emit) async {
    emit(LoadingAssessments());

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('userToken');

    if (token != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/dashboard');
        dev.log("Sending request to : $url");
        dev.log('Token Value For Dashboard Request: $token');

        final Map<String, String> _headers = {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        };

        dev.log(_headers["Authorization"]!);

        var response = await http.get(url, headers: _headers);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          dev.log("Dashboard Response: ${response.body}");

          emit(DashBoardLoaded(dashBoardData: data["dashboarddata"]));
        } else {
          dev.log("Error Occured");
        }
      } catch (e) {
        emit(DashBoardError(error: e.toString()));
        dev.log("Login Error: $e");
      }
    } else {
      emit(DashBoardError(error: "User Token Null"));
    }
  }
}
