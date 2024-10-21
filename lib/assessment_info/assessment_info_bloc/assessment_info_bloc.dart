import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:developer" as dev;
import "assessment_info_state.dart";
import 'assessment_info_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AssessmentInfoBloc
    extends Bloc<AssessmentInfoEvent, AssessmentInfoState> {
  AssessmentInfoBloc() : super(AssessmentInfoInitial()) {
    on<GetAssessmentInfo>(_getAssessmentInfo);
  }

  void _getAssessmentInfo(
      GetAssessmentInfo event, Emitter<AssessmentInfoState> emit) async {
    emit(AssessmentInfoLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? assessmentID = prefs.getString('assessmentID');
    String? userToken = prefs.getString('userToken');

    dev.log("Getting AssessmentInfo assessment ID: $assessmentID");
    dev.log("Getting AssessmentInfo user token: $userToken");

    if (assessmentID != null && userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/fetchpatient');

        var fetchBody = {
          "assessmentId": assessmentID,
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
          dev.log("AssessmentInfo Response: ${response.body}");
          if (response.body == "") {
            emit(AssessmentInfoLoaded(AssessmentInfoDataRec: null));
          } else {
            var data = jsonDecode(response.body);

            dev.log("Data Received: $data");
            emit(AssessmentInfoLoaded(AssessmentInfoDataRec: data));
          }
        } else {
          emit(AssessmentInfoError(
              error:
                  "Statude Code: ${response.statusCode} with error ${response.body}"));
        }
      } catch (e) {
        emit(AssessmentInfoError(error: e.toString()));
      }
    }
  }
}
