import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "sneh_jeeryaman_lakshana_state.dart";
import 'sneh_jeeryaman_lakshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SnehJeeryamanLakshanaBloc extends Bloc<SnehJeeryamanLakshanaEvent, SnehJeeryamanLakshanaState> {
  SnehJeeryamanLakshanaBloc() : super(SnehJeeryamanLakshanaInitial()) {
    on<CreateSnehJeeryamanLakshana>(_createSnehJeeryamanLakshana);
    on<GetSnehJeeryamanLakshana>(_getSnehJeeryamanLakshana);
    on<Day0SnehJeeryamanLakshana>(_firstPost);
  }

  void _firstPost(
      Day0SnehJeeryamanLakshana event, Emitter<SnehJeeryamanLakshanaState> emit) async {
    emit(CreatingSnehJeeryamanLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "SnehJeeryamanLakshana",
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
          emit(SnehJeeryamanLakshanaInitial());
        }
      } catch (e) {
        emit(SnehJeeryamanLakshanaError(error: e.toString()));
      }
    } else {
      emit(SnehJeeryamanLakshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createSnehJeeryamanLakshana(
      CreateSnehJeeryamanLakshana event, Emitter<SnehJeeryamanLakshanaState> emit) async {
    emit(CreatingSnehJeeryamanLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating SnehJeeryamanLakshana: ${json.encode(event.SnehJeeryamanLakshanaData)}");

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
          body: jsonEncode(event.SnehJeeryamanLakshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create SnehJeeryamanLakshana Response: ${response.body}");

          emit(SnehJeeryamanLakshanaCreated());
        }
      } catch (e) {
        emit(SnehJeeryamanLakshanaError(error: e.toString()));
      }
    } else {
      emit(SnehJeeryamanLakshanaError(error: "User not logged in"));
    }
  }

  void _getSnehJeeryamanLakshana(
      GetSnehJeeryamanLakshana event, Emitter<SnehJeeryamanLakshanaState> emit) async {
    emit(SnehJeeryamanLakshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting SnehJeeryamanLakshana assessment ID: $assessmentID");
    dev.log("Getting SnehJeeryamanLakshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "SnehJeeryamanLakshana",
          "day": event.dayNumber
        };
        var fetchBody0 = jsonEncode(fetchBody);

        dev.log(fetchBody0);

        dev.log("Sending request to : $url");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $userToken"
          },
          body: fetchBody0,
        );
        if (response.statusCode == 200) {
          dev.log("SnehJeeryamanLakshana Response: ${response.body}");
          if (response.body == "") {
            emit(SnehJeeryamanLakshanaLoaded(SnehJeeryamanLakshanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(SnehJeeryamanLakshanaLoaded(SnehJeeryamanLakshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(SnehJeeryamanLakshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(SnehJeeryamanLakshanaError(error: e.toString()));
      }
    }
  }
}
