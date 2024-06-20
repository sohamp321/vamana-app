import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "sarvanga_lakshana_state.dart";
import 'sarvanga_lakshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SarvangaLakshanaBloc
    extends Bloc<SarvangaLakshanaEvent, SarvangaLakshanaState> {
  SarvangaLakshanaBloc() : super(SarvangaLakshanaInitial()) {
    on<CreateSarvangaLakshana>(_createSarvangaLakshana);
    on<GetSarvangaLakshana>(_getSarvangaLakshana);
    on<Day0SarvangaLakshana>(_firstPost);
  }

  void _firstPost(
      Day0SarvangaLakshana event, Emitter<SarvangaLakshanaState> emit) async {
    emit(CreatingSarvangaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> sarvangaLakshanaReq = {
          "assessmentName": "SarvangaLakshana",
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
          body: jsonEncode(sarvangaLakshanaReq),
        );

        if (response.statusCode == 200) {
          emit(SarvangaLakshanaInitial());
        }
      } catch (e) {
        emit(SarvangaLakshanaError(error: e.toString()));
      }
    } else {
      emit(SarvangaLakshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createSarvangaLakshana(
      CreateSarvangaLakshana event, Emitter<SarvangaLakshanaState> emit) async {
    emit(CreatingSarvangaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log(
        "Creating SarvangaLakshana: ${json.encode(event.SarvangaLakshanaData)}");

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
          body: jsonEncode(event.SarvangaLakshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create SarvangaLakshana Response: ${response.body}");

          emit(SarvangaLakshanaCreated());
        }
      } catch (e) {
        emit(SarvangaLakshanaError(error: e.toString()));
      }
    } else {
      emit(SarvangaLakshanaError(error: "User not logged in"));
    }
  }

  void _getSarvangaLakshana(
      GetSarvangaLakshana event, Emitter<SarvangaLakshanaState> emit) async {
    emit(SarvangaLakshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting SarvangaLakshana assessment ID: $assessmentID");
    dev.log("Getting SarvangaLakshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "SarvangaLakshana",
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
          dev.log("SarvangaLakshana Response: ${response.body}");
          if (response.body == "") {
            emit(SarvangaLakshanaLoaded(SarvangaLakshanaDataRec: null));
          } else {
            Map<String, dynamic> data = jsonDecode(response.body);
            emit(SarvangaLakshanaLoaded(SarvangaLakshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(SarvangaLakshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(SarvangaLakshanaError(error: e.toString()));
      }
    }
  }
}
