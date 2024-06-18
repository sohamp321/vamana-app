import 'package:equatable/equatable.dart';

abstract class NewAssessmentState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewAssessmentInitial extends NewAssessmentState {}

class UpdatedPatientDetails extends NewAssessmentState {
  final Map<String, dynamic> patientInfo;

  UpdatedPatientDetails({required this.patientInfo});

  @override
  List<Object> get props => [patientInfo];
}

class UpdatedComplaints extends NewAssessmentState {
  final Map<String, dynamic> complaintsInfo;

  UpdatedComplaints({required this.complaintsInfo});

  @override
  List<Object> get props => [complaintsInfo];
}

class UpdatedInvestigations extends NewAssessmentState {
  final Map<String, dynamic> investigationsInfo;

  UpdatedInvestigations({required this.investigationsInfo});

  @override
  List<Object> get props => [investigationsInfo];
}

class UpdatedPoorvaKarma extends NewAssessmentState {
  final Map<String, dynamic> poorvaKarmaInfo;

  UpdatedPoorvaKarma({required this.poorvaKarmaInfo});

  @override
  List<Object> get props => [poorvaKarmaInfo];
}

class UpdatingInfo extends NewAssessmentState {}

class CreatingAssessment extends NewAssessmentState {}

class CreatedAssessment extends NewAssessmentState {
  String assessmentID;

  CreatedAssessment({required this.assessmentID});

 @override
  List<Object> get props => [assessmentID];

}

class NewAssessmentError extends NewAssessmentState {
  String error;

  NewAssessmentError({required this.error});

  @override
  List<Object> get props => [error];
}
