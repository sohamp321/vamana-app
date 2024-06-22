import 'package:equatable/equatable.dart';

abstract class SnehanaLakshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SnehanaLakshanaInitial extends SnehanaLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehanaLakshanaLoading extends SnehanaLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehanaLakshanaLoaded extends SnehanaLakshanaState {
  final Map<String, dynamic>? SnehanaLakshanaDataRec;
  SnehanaLakshanaLoaded({required this.SnehanaLakshanaDataRec});
  @override
  List<Object?> get props => [SnehanaLakshanaDataRec];
}

class SnehanaLakshanaCreated extends SnehanaLakshanaState {
  @override
  List<Object> get props => [];
}

class SnehanaLakshanaError extends SnehanaLakshanaState {
  final String error;
  SnehanaLakshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingSnehanaLakshana extends SnehanaLakshanaState {
   @override
  List<Object> get props => [];
}
