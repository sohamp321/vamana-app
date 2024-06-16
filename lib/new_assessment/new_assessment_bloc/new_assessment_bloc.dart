import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_assessment_event.dart';
import 'new_assessment_state.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

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

  void updateComplaintsInfo(UpdateComplaints event, Emitter<NewAssessmentState> emit){
    emit(UpdatingInfo());

    complaintsInfo = event.complaintsInfo;

    dev.log("Updated Complaints Info Stored: ${complaintsInfo.toString()}");

    emit(UpdatedComplaints(complaintsInfo: complaintsInfo));
  }

  void updateInvestigationsInfo(UpdateInvestigations event, Emitter<NewAssessmentState> emit){
    emit(UpdatingInfo());

    investigationsInfo = event.investigationsInfo;

    dev.log("Updated Investigations Info Stored: ${investigationsInfo.toString()}");

    emit(UpdatedInvestigations(investigationsInfo: investigationsInfo));
  }

  void updatePoorvaKarmaInfo(UpdatePoorvaKarma event, Emitter<NewAssessmentState> emit){
    emit(UpdatingInfo());

    poorvaKarmaInfo = event.poorvaKarmaInfo;

    dev.log("Updated Poorva Karma Info Stored: ${poorvaKarmaInfo.toString()}");

    emit(UpdatedPoorvaKarma(poorvaKarmaInfo: poorvaKarmaInfo));
  }

  void createAssessment(CreateAssessment event, Emitter<NewAssessmentState> emit){
    emit(CreatingAssessment());

    dev.log("Creating New Assessment");

    dev.log("Patient Info: ${patientInfo.toString()}");
    dev.log("Complaints Info: ${complaintsInfo.toString()}");
    dev.log("Investigations Info: ${investigationsInfo.toString()}");
    dev.log("Poorva Karma Info: ${poorvaKarmaInfo.toString()}");

    // TODO: Implement New Assessment Creation

    emit(CreatedAssessment());
  }

}
