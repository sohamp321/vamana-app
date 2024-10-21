import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "snehapana_state.dart";
import 'snehapana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SnehapanaBloc extends Bloc<SnehapanaEvent, SnehapanaState> {
  SnehapanaBloc() : super(SnehapanaInitial()) {
    on<CreateSnehapana>(_createSnehapana);
    on<GetSnehapana>(_getSnehapana);
    on<Day0Snehapana>(_firstPost);
  }

  void _firstPost(
      Day0Snehapana event, Emitter<SnehapanaState> emit) async {
    emit(CreatingSnehapana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "Snehapana",
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
          emit(SnehapanaInitial());
        }
      } catch (e) {
        emit(SnehapanaError(error: e.toString()));
      }
    } else {
      emit(SnehapanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createSnehapana(
      CreateSnehapana event, Emitter<SnehapanaState> emit) async {
    emit(CreatingSnehapana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating Snehapana: ${json.encode(event.SnehapanaData)}");

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
          body: jsonEncode(event.SnehapanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create Snehapana Response: ${response.body}");

          emit(SnehapanaCreated());
        }
      } catch (e) {
        emit(SnehapanaError(error: e.toString()));
      }
    } else {
      emit(SnehapanaError(error: "User not logged in"));
    }
  }

  void _getSnehapana(
      GetSnehapana event, Emitter<SnehapanaState> emit) async {
    emit(SnehapanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting Snehapana assessment ID: $assessmentID");
    dev.log("Getting Snehapana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "Snehapana",
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
          dev.log("Snehapana Response: ${response.body}");
          if (response.body == "") {
            emit(SnehapanaLoaded(SnehapanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(SnehapanaLoaded(SnehapanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(SnehapanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(SnehapanaError(error: e.toString()));
      }
    }
  }
}
