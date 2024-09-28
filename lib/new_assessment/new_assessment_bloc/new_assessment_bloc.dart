import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_assessment_event.dart';
import 'new_assessment_state.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:bson/bson.dart";

class NewAssessmentBloc extends Bloc<NewAssessmentEvent, NewAssessmentState> {
  Map<String, dynamic> patientInfo = {};
  Map<String, dynamic> complaintsInfo = {};
  Map<String, dynamic> investigationsInfo = {};
  Map<String, dynamic> poorvaKarmaInfo = {};
  NewAssessmentBloc() : super(NewAssessmentInitial()) {
    on<UpdatePatientDetails>(updatePatientInfo);
    on<UpdateComplaints>(updateComplaintsInfo);
    on<UpdateInvestigations>(updateInvestigationsInfo);
    on<UpdatePoorvaKarma>(updatePoorvaKarmaInfo);
    on<CreateAssessment>(createAssessment);
  }

  void updatePatientInfo(
      UpdatePatientDetails event, Emitter<NewAssessmentState> emit) {
    emit(UpdatingInfo());

    patientInfo = event.patientInfo;

    dev.log("Updated Patient Info Stored: ${patientInfo.toString()}");

    emit(UpdatedPatientDetails(patientInfo: patientInfo));
  }

  void updateComplaintsInfo(
      UpdateComplaints event, Emitter<NewAssessmentState> emit) {
    emit(UpdatingInfo());

    complaintsInfo = event.complaintsInfo;

    dev.log("Updated Complaints Info Stored: ${complaintsInfo.toString()}");

    emit(UpdatedComplaints(complaintsInfo: complaintsInfo));
  }

  void updateInvestigationsInfo(
      UpdateInvestigations event, Emitter<NewAssessmentState> emit) {
    emit(UpdatingInfo());

    investigationsInfo = event.investigationsInfo;

    dev.log(
        "Updated Investigations Info Stored: ${investigationsInfo.toString()}");

    emit(UpdatedInvestigations(investigationsInfo: investigationsInfo));
  }

  void updatePoorvaKarmaInfo(
      UpdatePoorvaKarma event, Emitter<NewAssessmentState> emit) {
    emit(UpdatingInfo());

    poorvaKarmaInfo = event.poorvaKarmaInfo;

    dev.log("Updated Poorva Karma Info Stored: ${poorvaKarmaInfo.toString()}");

    emit(UpdatedPoorvaKarma(poorvaKarmaInfo: poorvaKarmaInfo));
  }

  void createAssessment(
      CreateAssessment event, Emitter<NewAssessmentState> emit) async {
    emit(CreatingAssessment());

    Map<String, dynamic> addRequest = {
      "uhid": patientInfo["UHID"],
      "name": patientInfo["Name"],
      "DOB": patientInfo["Date of Birth"],
      "occupation": patientInfo["Occupation"],
      "address": patientInfo["Address"],
      "pastIllness": patientInfo["Past Illness"],
      "medicalHistory": patientInfo["Medical History"],
      "complaints": {
        "avipaka": complaintsInfo["Avipaka(Indigestion)"],
        "trishana": complaintsInfo["Trishna(Feeling thirsty)"],
        "aruchi": complaintsInfo["Aruchi(Anorexia)"],
        "gauravam": complaintsInfo["Gauravam(Heaviness)"],
        "alasya": complaintsInfo["Aalasya(Laziness)"],
        "nidranaasha": complaintsInfo["Nidranaasha(Sleeplessness)"],
        "atinidrata": complaintsInfo["Atinidrata(excessive sleep)"],
        "ashasta_swapna_darshanam":
            complaintsInfo["Ashasta-swapna-darshanam (Abnormal dreams)"],
        "tandra": complaintsInfo["Tandra (somnolent/feeling sleepy)"],
        "shrama": complaintsInfo["Shrama (Breathlessnesswhile exertion)"],
        "daurbalayam": complaintsInfo["Daurbalayam (Weakness)"],
        "klamah": complaintsInfo["Klamah (Fatigue)"],
        "sthaulyam": complaintsInfo["Sthaulyam (Obesity)"],
        "pitta_samutklesha":
            complaintsInfo["Pitta-samutklesha (Vitiated Pitta Features)"],
        "shleshma_samutklesha":
            complaintsInfo["Shleshma-samutklesha (Vitiated Kapha Features)"],
        "panduta": complaintsInfo["Panduta (Anaemic)"],
        "kandu": complaintsInfo["Kandu (Itching)"],
        "pidka_kotha": complaintsInfo["Pidka,Kotha (Skin eruptions)"],
        "daurgandhyatvam": complaintsInfo[
            "Daurgandhyatvam (Foul smell from sweat, stool, urine etc.)"],
        "arati": complaintsInfo["Arati (Disturbed mind)"],
        "avasadaka": complaintsInfo["Avasadaka (Depressed Mind)"],
        "bala_pranasha_brumhanairapi": complaintsInfo[
            "Bala-pranasha/ Brumhanairapi (Loss of physical strength even after taking good diet)"],
        "varna_pranasha": complaintsInfo["Varna-pranasha (Loss of glow)"],
        "abudhitvam": complaintsInfo["Abudhitvam (absent mindedness)"],
        "klaibyam": complaintsInfo["Klaibyam (Lost Vitality)"],
      },
      "investigations": investigationsInfo,
      "poorvaKarma": poorvaKarmaInfo
    };

    var _addRequest = jsonEncode(addRequest);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString("userToken");
   

    if (_userToken != null) {
      try {
        var url = Uri.parse('${dotenv.env["SERVER_URL"]}/add');
        dev.log("Sending request to : $url");
        dev.log("Request Body: $_addRequest");
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $_userToken"
          },
          body: _addRequest,
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          dev.log(" Response: ${response.body}");

          dev.log("Assessment ID: ${data["_id"]}");

          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('assessmentID', data["_id"]);

          dev.log("Assessment ID: ${prefs.getString("assessmentID")}");

          emit(CreatedAssessment(assessmentID: data["_id"]));
        } else {
          dev.log(
              "Error Occured with code : ${response.statusCode} and error message : ${response.body}");
              emit(NewAssessmentError(error: "Error Occured with code : ${response.statusCode} and error message : ${response.body}"));
        }
      } catch (e) {
        emit(NewAssessmentError(error: e.toString()));
        dev.log("Login Error: $e");
      }
    }
  }
}
