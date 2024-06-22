import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "vega_nirikshana_state.dart";
import 'vega_nirikshana_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class VegaNirikshanaBloc extends Bloc<VegaNirikshanaEvent, VegaNirikshanaState> {
  VegaNirikshanaBloc() : super(VegaNirikshanaInitial()) {
    on<CreateVegaNirikshana>(_createVegaNirikshana);
    on<GetVegaNirikshana>(_getVegaNirikshana);
    on<Day0VegaNirikshana>(_firstPost);
  }

  void _firstPost(
      Day0VegaNirikshana event, Emitter<VegaNirikshanaState> emit) async {
    emit(CreatingVegaNirikshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "VegaNirikshana",
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
          emit(VegaNirikshanaInitial());
        }
      } catch (e) {
        emit(VegaNirikshanaError(error: e.toString()));
      }
    } else {
      emit(VegaNirikshanaError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createVegaNirikshana(
      CreateVegaNirikshana event, Emitter<VegaNirikshanaState> emit) async {
    emit(CreatingVegaNirikshana());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating VegaNirikshana: ${json.encode(event.VegaNirikshanaData)}");

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
          body: jsonEncode(event.VegaNirikshanaData),
        );

        if (response.statusCode == 200) {
          dev.log("Create VegaNirikshana Response: ${response.body}");

          emit(VegaNirikshanaCreated());
        }
      } catch (e) {
        emit(VegaNirikshanaError(error: e.toString()));
      }
    } else {
      emit(VegaNirikshanaError(error: "User not logged in"));
    }
  }

  void _getVegaNirikshana(
      GetVegaNirikshana event, Emitter<VegaNirikshanaState> emit) async {
    emit(VegaNirikshanaLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting VegaNirikshana assessment ID: $assessmentID");
    dev.log("Getting VegaNirikshana user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "VegaNirikshana",
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
          dev.log("VegaNirikshana Response: ${response.body}");
          if (response.body == "") {
            emit(VegaNirikshanaLoaded(VegaNirikshanaDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(VegaNirikshanaLoaded(VegaNirikshanaDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(VegaNirikshanaError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(VegaNirikshanaError(error: e.toString()));
      }
    }
  }
}
