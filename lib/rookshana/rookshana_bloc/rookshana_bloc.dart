import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "rookshana_state.dart";
import 'rookshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RookshanaBloc
    extends Bloc<RookshanaEvent, RookshanaState> {
  RookshanaBloc() : super(RookshanaInitial()) {
    on<CreateRookshana>(_createRookshana);
    on<GetRookshana>(_getRookshana);
    on<Day0Rookshana>(_firstPost);
  }

  void _firstPost(
      Day0Rookshana event, Emitter<RookshanaState> emit) async {
    emit(CreatingRookshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> RookshanaReq = {
          "assessmentName": "Rookshana",
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
          body: jsonEncode(RookshanaReq),
        );

        if (response.statusCode == 200) {
          emit(RookshanaInitial());
        }
      } catch (e) {
        emit(RookshanaError(error: e.toString()));
      }
    } else {
      emit(RookshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createRookshana(
      CreateRookshana event, Emitter<RookshanaState> emit) async {
    emit(CreatingRookshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log(
        "Creating Rookshana: ${json.encode(event.RookshanaData)}");

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
          body: jsonEncode(event.RookshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create Rookshana Response: ${response.body}");

          emit(RookshanaCreated());
        }
      } catch (e) {
        emit(RookshanaError(error: e.toString()));
      }
    } else {
      emit(RookshanaError(error: "User not logged in"));
    }
  }

  void _getRookshana(
      GetRookshana event, Emitter<RookshanaState> emit) async {
    emit(RookshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting Rookshana assessment ID: $assessmentID");
    dev.log("Getting Rookshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "Rookshana",
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
          dev.log("Rookshana Response: ${response.body}");
          if (response.body == "") {
            emit(RookshanaLoaded(RookshanaDataRec: null));
          } else {
            Map<String, dynamic> data = jsonDecode(response.body);
            emit(RookshanaLoaded(RookshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(RookshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(RookshanaError(error: e.toString()));
      }
    }
  }
}
