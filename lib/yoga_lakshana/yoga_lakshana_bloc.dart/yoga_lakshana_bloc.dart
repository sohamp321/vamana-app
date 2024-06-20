import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "yoga_lakshana_state.dart";
import 'yoga_lakshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class YogaLakshanaBloc extends Bloc<YogaLakshanaEvent, YogaLakshanaState> {
  YogaLakshanaBloc() : super(YogaLakshanaInitial()) {
    on<CreateYogaLakshana>(_createYogaLakshana);
    on<GetYogaLakshana>(_getYogaLakshana);
    on<Day0YogaLakshana>(_firstPost);
  }

  void _firstPost(
      Day0YogaLakshana event, Emitter<YogaLakshanaState> emit) async {
    emit(CreatingYogaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "YogaLakshana",
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
          emit(YogaLakshanaInitial());
        }
      } catch (e) {
        emit(YogaLakshanaError(error: e.toString()));
      }
    } else {
      emit(YogaLakshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createYogaLakshana(
      CreateYogaLakshana event, Emitter<YogaLakshanaState> emit) async {
    emit(CreatingYogaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log(event.YogaLakshanaData.toString());

    dev.log("Creating YogaLakshana: ${json.encode(event.YogaLakshanaData)}");

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
          body: jsonEncode(event.YogaLakshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create YogaLakshana Response: ${response.body}");

          emit(YogaLakshanaCreated());
        }
      } catch (e) {
        emit(YogaLakshanaError(error: e.toString()));
      }
    } else {
      emit(YogaLakshanaError(error: "User not logged in"));
    }
  }

  void _getYogaLakshana(
      GetYogaLakshana event, Emitter<YogaLakshanaState> emit) async {
    emit(YogaLakshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting YogaLakshana assessment ID: $assessmentID");
    dev.log("Getting YogaLakshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "YogaLakshana",
          "day": "1"
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
          dev.log("YogaLakshana Response: ${response.body}");
          if (response.body == "") {
            emit(YogaLakshanaLoaded(
                YogaLakshanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(YogaLakshanaLoaded(
                YogaLakshanaDataRec: data["data"],
                ));
          }
        }
        // } else {
        //   emit(YogaLakshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(YogaLakshanaError(error: e.toString()));
      }
    }
  }
}
