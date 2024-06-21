import 'package:equatable/equatable.dart';

abstract class RookshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RookshanaInitial extends RookshanaState {
  @override
  List<Object> get props => [];
}

class RookshanaLoading extends RookshanaState {
  @override
  List<Object> get props => [];
}

class RookshanaLoaded extends RookshanaState {
  final Map<String, dynamic>? RookshanaDataRec;
  RookshanaLoaded({required this.RookshanaDataRec});
  @override
  List<Object?> get props => [RookshanaDataRec];
}

class RookshanaCreated extends RookshanaState {
  @override
  List<Object> get props => [];
}

class RookshanaError extends RookshanaState {
  final String error;
  RookshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingRookshana extends RookshanaState {
  @override
  List<Object> get props => [];
}
