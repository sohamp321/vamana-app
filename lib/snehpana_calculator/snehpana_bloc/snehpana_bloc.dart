import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "snehpana_state.dart";
import '../snehpana_bloc/snehpana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AamaLakshanaBloc extends Bloc<AamaLakshanaEvent, AamaLakshanaState> {
  AamaLakshanaBloc() : super(AamaLakshanaInitial()) {
    on<CreateAamaLakshana>(_createAamaLakshana);
    on<GetAamaLakshana>(_getAamaLakshana);
    on<Day0AamaLakshana>(_firstPost);
  }

  void _firstPost(
      Day0AamaLakshana event, Emitter<AamaLakshanaState> emit) async {
    emit(CreatingAamaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "aamaLakshana",
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
          emit(AamaLakshanaInitial());
        }
      } catch (e) {
        emit(AamaLakshanaError(error: e.toString()));
      }
    } else {
      emit(AamaLakshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createAamaLakshana(
      CreateAamaLakshana event, Emitter<AamaLakshanaState> emit) async {
    emit(CreatingAamaLakshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating AamaLakshana: ${json.encode(event.aamaLakshanaData)}");

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
          body: jsonEncode(event.aamaLakshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create AamaLakshana Response: ${response.body}");

          emit(AamaLakshanaCreated());
        }
      } catch (e) {
        emit(AamaLakshanaError(error: e.toString()));
      }
    } else {
      emit(AamaLakshanaError(error: "User not logged in"));
    }
  }

  void _getAamaLakshana(
      GetAamaLakshana event, Emitter<AamaLakshanaState> emit) async {
    emit(AamaLakshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting AamaLakshana assessment ID: $assessmentID");
    dev.log("Getting AamaLakshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "aamaLakshana",
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
          dev.log("AamaLakshana Response: ${response.body}");
          if (response.body == "") {
            emit(AamaLakshanaLoaded(aamaLakshanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(AamaLakshanaLoaded(aamaLakshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(AamaLakshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(AamaLakshanaError(error: e.toString()));
      }
    }
  }
}
