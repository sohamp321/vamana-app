import 'package:equatable/equatable.dart';

abstract class YogaLakshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class YogaLakshanaInitial extends YogaLakshanaState {
  @override
  List<Object> get props => [];
}

class YogaLakshanaLoading extends YogaLakshanaState {
  @override
  List<Object> get props => [];
}

class YogaLakshanaLoaded extends YogaLakshanaState {
  final Map<String, dynamic>? YogaLakshanaDataRec;
  final String selectedLakshana;
  YogaLakshanaLoaded({required this.YogaLakshanaDataRec, required this.selectedLakshana});
  @override
  List<Object?> get props => [YogaLakshanaDataRec, selectedLakshana];
}

class YogaLakshanaCreated extends YogaLakshanaState {
  @override
  List<Object> get props => [];
}

class YogaLakshanaError extends YogaLakshanaState {
  final String error;
  YogaLakshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingYogaLakshana extends YogaLakshanaState {
  @override
  List<Object> get props => [];
}
