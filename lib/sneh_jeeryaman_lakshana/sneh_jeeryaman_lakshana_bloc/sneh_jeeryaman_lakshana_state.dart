import 'package:equatable/equatable.dart';

abstract class SnehJeeryamanLakshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SnehJeeryamanLakshanaInitial extends SnehJeeryamanLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehJeeryamanLakshanaLoading extends SnehJeeryamanLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehJeeryamanLakshanaLoaded extends SnehJeeryamanLakshanaState {
  final Map<String, dynamic>? SnehJeeryamanLakshanaDataRec;
  SnehJeeryamanLakshanaLoaded({required this.SnehJeeryamanLakshanaDataRec});
  @override
  List<Object?> get props => [SnehJeeryamanLakshanaDataRec];
}

class SnehJeeryamanLakshanaCreated extends SnehJeeryamanLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehJeeryamanLakshanaError extends SnehJeeryamanLakshanaState {
  final String error;
  SnehJeeryamanLakshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingSnehJeeryamanLakshana extends SnehJeeryamanLakshanaState {
   @override
  List<Object> get props => [];
}
