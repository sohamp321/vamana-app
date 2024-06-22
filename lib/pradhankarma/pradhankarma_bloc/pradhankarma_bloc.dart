import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "pradhankarma_state.dart";
import 'pradhankarma_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PradhanKarmaBloc extends Bloc<PradhanKarmaEvent, PradhanKarmaState> {
  PradhanKarmaBloc() : super(PradhanKarmaInitial()) {
    on<CreatePradhanKarma>(_createPradhanKarma);
    on<GetPradhanKarma>(_getPradhanKarma);
    on<Day0PradhanKarma>(_firstPost);
  }

  void _firstPost(
      Day0PradhanKarma event, Emitter<PradhanKarmaState> emit) async {
    emit(CreatingPradhanKarma());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "PradhanKarma",
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
          emit(PradhanKarmaInitial());
        }
      } catch (e) {
        emit(PradhanKarmaError(error: e.toString()));
      }
    } else {
      emit(PradhanKarmaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createPradhanKarma(
      CreatePradhanKarma event, Emitter<PradhanKarmaState> emit) async {
    emit(CreatingPradhanKarma());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating PradhanKarma: ${json.encode(event.PradhanKarmaData)}");

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
          body: jsonEncode(event.PradhanKarmaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create PradhanKarma Response: ${response.body}");

          emit(PradhanKarmaCreated());
        }
      } catch (e) {
        emit(PradhanKarmaError(error: e.toString()));
      }
    } else {
      emit(PradhanKarmaError(error: "User not logged in"));
    }
  }

  void _getPradhanKarma(
      GetPradhanKarma event, Emitter<PradhanKarmaState> emit) async {
    emit(PradhanKarmaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting PradhanKarma assessment ID: $assessmentID");
    dev.log("Getting PradhanKarma user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "PradhanKarma",
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
          dev.log("PradhanKarma Response: ${response.body}");
          if (response.body == "") {
            emit(PradhanKarmaLoaded(PradhanKarmaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(PradhanKarmaLoaded(PradhanKarmaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(PradhanKarmaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(PradhanKarmaError(error: e.toString()));
      }
    }
  }
}
