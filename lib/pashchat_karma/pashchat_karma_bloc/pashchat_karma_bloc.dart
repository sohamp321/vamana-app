import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "pashchat_karma_state.dart";
import 'pashchat_karma_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PashchatKarmaBloc extends Bloc<PashchatKarmaEvent, PashchatKarmaState> {
  PashchatKarmaBloc() : super(PashchatKarmaInitial()) {
    on<CreatePashchatKarma>(_createPashchatKarma);
    on<GetPashchatKarma>(_getPashchatKarma);
    on<Day0PashchatKarma>(_firstPost);
  }

  void _firstPost(
      Day0PashchatKarma event, Emitter<PashchatKarmaState> emit) async {
    emit(CreatingPashchatKarma());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "PashchatKarma",
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
          emit(PashchatKarmaInitial());
        }
      } catch (e) {
        emit(PashchatKarmaError(error: e.toString()));
      }
    } else {
      emit(PashchatKarmaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createPashchatKarma(
      CreatePashchatKarma event, Emitter<PashchatKarmaState> emit) async {
    emit(CreatingPashchatKarma());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating PashchatKarma: ${json.encode(event.PashchatKarmaData)}");

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
          body: jsonEncode(event.PashchatKarmaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create PashchatKarma Response: ${response.body}");

          emit(PashchatKarmaCreated());
        }
      } catch (e) {
        emit(PashchatKarmaError(error: e.toString()));
      }
    } else {
      emit(PashchatKarmaError(error: "User not logged in"));
    }
  }

  void _getPashchatKarma(
      GetPashchatKarma event, Emitter<PashchatKarmaState> emit) async {
    emit(PashchatKarmaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting PashchatKarma assessment ID: $assessmentID");
    dev.log("Getting PashchatKarma user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "PashchatKarma",
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
          dev.log("PashchatKarma Response: ${response.body}");
          if (response.body == "") {
            emit(PashchatKarmaLoaded(PashchatKarmaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(PashchatKarmaLoaded(PashchatKarmaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(PashchatKarmaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(PashchatKarmaError(error: e.toString()));
      }
    }
  }
}
