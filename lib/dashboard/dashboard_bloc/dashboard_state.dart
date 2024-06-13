import 'package:equatable/equatable.dart';

abstract class DashBoardState extends Equatable {
  @override
  List<Object> get props => [];
}
class DashBoardInitial extends DashBoardState{}

class LoadingAssessments extends DashBoardState {}

class DashBoardLoaded extends DashBoardState {
  final List<dynamic> dashBoardData;

  DashBoardLoaded({required this.dashBoardData});

  @override
  List<Object> get props => [dashBoardData];
}

class ChosenAssessment extends DashBoardState {
  final String assessmentID;

  ChosenAssessment({required this.assessmentID});

  @override
  List<Object> get props => [assessmentID];
}

class DashBoardError extends DashBoardState {
  final String error;
  DashBoardError({required this.error});

  @override
  List<Object> get props => [error];
}
