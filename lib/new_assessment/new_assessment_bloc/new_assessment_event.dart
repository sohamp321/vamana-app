import "package:equatable/equatable.dart";

abstract class NewAssessmentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateAssessment extends NewAssessmentEvent {
  Map<String, dynamic> patientInfo;
  Map<String, dynamic> complaintsInfo;
  Map<String, dynamic> investigationsInfo;
  Map<String, dynamic> poorvaKarmaInfo;

  CreateAssessment(
      {required this.patientInfo,
      required this.complaintsInfo,
      required this.investigationsInfo,
      required this.poorvaKarmaInfo});

  @override
  List<Object> get props =>
      [patientInfo, complaintsInfo, investigationsInfo, poorvaKarmaInfo];
}

class UpdatePatientDetails extends NewAssessmentEvent {
  Map<String, dynamic> patientInfo;

  UpdatePatientDetails({required this.patientInfo});

  @override
  List<Object> get props => [patientInfo];
}

class UpdateComplaints extends NewAssessmentEvent {
  Map<String, dynamic> complaintsInfo;

  UpdateComplaints({required this.complaintsInfo});

  @override
  List<Object> get props => [complaintsInfo];
}

class UpdateInvestigations extends NewAssessmentEvent {
  Map<String, dynamic> investigationsInfo;

  UpdateInvestigations({required this.investigationsInfo});

  @override
  List<Object> get props => [investigationsInfo];
}

class UpdatePoorvaKarma extends NewAssessmentEvent {
  Map<String, dynamic> poorvaKarmaInfo;

  UpdatePoorvaKarma({required this.poorvaKarmaInfo});

  @override
  List<Object> get props => [poorvaKarmaInfo];
}
