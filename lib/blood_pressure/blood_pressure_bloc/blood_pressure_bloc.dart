import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vamana_app/new_assessment/new_assessment_bloc/new_assessment_state.dart';
import "dart:developer" as dev;
import "blood_pressure_state.dart";
import 'blood_pressure_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class BloodPressureBloc extends Bloc<BloodPressureEvent, BloodPressureState> {
  BloodPressureBloc() : super(BloodPressureInitial()) {
    on<CreateBloodPressure>(_createBloodPressure);
    on<GetBloodPressure>(_getBloodPressure);
    on<Day0BloodPressure>(_firstPost);
  }

  void _firstPost(
      Day0BloodPressure event, Emitter<BloodPressureState> emit) async {
    emit(CreatingBloodPressure());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? assessmentID = prefs.getString('assessmentID');

    if (userToken != null && assessmentID != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/addsingle');

        dev.log("Sending request to : $url");

        Map<String, dynamic> aamaLakshanReq = {
          "assessmentName": "BloodPressure",
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
          emit(BloodPressureInitial());
        }
      } catch (e) {
        emit(BloodPressureError(error: e.toString()));
      }
    } else {
      emit(BloodPressureError(
          error: "User not logged in/ Assessment ID Invalid"));
    }
  }

  void _createBloodPressure(
      CreateBloodPressure event, Emitter<BloodPressureState> emit) async {
    emit(CreatingBloodPressure());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    dev.log("Creating BloodPressure: ${json.encode(event.BloodPressureData)}");

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
          body: jsonEncode(event.BloodPressureData),
        );

        if (response.statusCode == 200) {
          dev.log("Create BloodPressure Response: ${response.body}");

          emit(BloodPressureCreated());
        }
      } catch (e) {
        emit(BloodPressureError(error: e.toString()));
      }
    } else {
      emit(BloodPressureError(error: "User not logged in"));
    }
  }

  void _getBloodPressure(
      GetBloodPressure event, Emitter<BloodPressureState> emit) async {
    emit(BloodPressureLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting BloodPressure assessment ID: $assessmentID");
    dev.log("Getting BloodPressure user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchsingle');

        var fetchBody = {
          "id": assessmentID,
          "assessmentName": "BloodPressure",
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
          dev.log("BloodPressure Response: ${response.body}");
          if (response.body == "") {
            emit(BloodPressureLoaded(BloodPressureDataRec: null));
          } else {
            var data = jsonDecode(response.body);
            emit(BloodPressureLoaded(BloodPressureDataRec: data["data"]));
          }
        }
        // } else {
        //   emit(BloodPressureError(
        //       error:
        //           "Statude Code: ${response.statusCode} with error ${response.body}"));
        // }
      } catch (e) {
        emit(BloodPressureError(error: e.toString()));
      }
    }
  }
}
