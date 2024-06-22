import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "snehana_lakshana_state.dart";
import 'snehana_lakshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SnehanaLakshanaBloc extends Bloc<SnehanaLakshanaEvent, SnehanaLakshanaState> {
  SnehanaLakshanaBloc() : super(SnehanaLakshanaInitial()) {
    on<CreateSnehanaLakshana>(_createSnehanaLakshana);
    on<GetSnehanaLakshana>(_getSnehanaLakshana);
    on<Day0SnehanaLakshana>(_firstPost);
  }

  void _firstPost(
      Day0SnehanaLakshana event, Emitter<SnehanaLakshanaState> emit) async {
    emit(CreatingSnehanaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "SnehanaLakshana",
          "day": "0",
          "id": assessmentID,
          "data": {}
        };

        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: jsonEncode(aamaLakshanReq),
        );

        if (response.statusCode == 200) {
          emit(SnehanaLakshanaInitial());
        }
      } catch (e) {
        emit(SnehanaLakshanaError(error: e.toString()));
      }
    } else {
      emit(SnehanaLakshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createSnehanaLakshana(
      CreateSnehanaLakshana event, Emitter<SnehanaLakshanaState> emit) async {
    emit(CreatingSnehanaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating SnehanaLakshana: ${json.encode(event.SnehanaLakshanaData)}");

    if (userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: jsonEncode(event.SnehanaLakshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create SnehanaLakshana Response: ${response.body}");

          emit(SnehanaLakshanaCreated());
        }
      } catch (e) {
        emit(SnehanaLakshanaError(error: e.toString()));
      }
    } else {
      emit(SnehanaLakshanaError(error: "User not logged in"));
    }
  }

  void _getSnehanaLakshana(
      GetSnehanaLakshana event, Emitter<SnehanaLakshanaState> emit) async {
    emit(SnehanaLakshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting SnehanaLakshana assessment ID: $assessmentID");
    dev.log("Getting SnehanaLakshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "SnehanaLakshana",
          "day": event.dayNumber
        };
        var _fetchBody = jsonEncode(fetchBody);

        dev.log(_fetchBody);

        dev.log("Sending request to : $url");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: _fetchBody,
        );
        if (response.statusCode == 200) {
          dev.log("SnehanaLakshana Response: ${response.body}");
          if (response.body == "") {
            emit(SnehanaLakshanaLoaded(SnehanaLakshanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(SnehanaLakshanaLoaded(SnehanaLakshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(SnehanaLakshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(SnehanaLakshanaError(error: e.toString()));
      }
    }
  }
}
