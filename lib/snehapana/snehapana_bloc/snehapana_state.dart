import 'package:equatable/equatable.dart';

abstract class SnehapanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SnehapanaInitial extends SnehapanaState {
  @override
  List<Object> get props => [];
}

class SnehapanaLoading extends SnehapanaState {
  @override
  List<Object> get props => [];
}

class SnehapanaLoaded extends SnehapanaState {
  final Map<String, dynamic>? SnehapanaDataRec;
  SnehapanaLoaded({required this.SnehapanaDataRec});
  @override
  List<Object?> get props => [SnehapanaDataRec];
}

class SnehapanaCreated extends SnehapanaState {
  @override
  List<Object> get props => [];
}

class SnehapanaError extends SnehapanaState {
  final String error;
  SnehapanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingSnehapana extends SnehapanaState {
   @override
  List<Object> get props => [];
}
