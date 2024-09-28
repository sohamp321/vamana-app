import 'package:equatable/equatable.dart';

abstract class AssessmentInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssessmentInfoInitial extends AssessmentInfoState {
  @override
  List<Object> get props => [];
}

class AssessmentInfoLoading extends AssessmentInfoState {
  @override
  List<Object> get props => [];
}

class AssessmentInfoLoaded extends AssessmentInfoState {
  final Map<String, dynamic>? AssessmentInfoDataRec;
  AssessmentInfoLoaded({required this.AssessmentInfoDataRec});
  @override
  List<Object?> get props => [AssessmentInfoDataRec];
}

class AssessmentInfoError extends AssessmentInfoState {
  final String error;
  AssessmentInfoError({required this.error});
  @override
  List<Object> get props => [error];
}
