import 'package:equatable/equatable.dart';

abstract class AamaLakshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AamaLakshanaInitial extends AamaLakshanaState {
  @override
  List<Object> get props => [];
}

class AamaLakshanaLoading extends AamaLakshanaState {
  @override
  List<Object> get props => [];
}

class AamaLakshanaLoaded extends AamaLakshanaState {
  final Map<String, dynamic>? aamaLakshanaDataRec;
  AamaLakshanaLoaded({required this.aamaLakshanaDataRec});
  @override
  List<Object?> get props => [aamaLakshanaDataRec];
}

class AamaLakshanaCreated extends AamaLakshanaState {
  @override
  List<Object> get props => [];
}

class AamaLakshanaError extends AamaLakshanaState {
  final String error;
  AamaLakshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingAamaLakshana extends AamaLakshanaState {
   @override
  List<Object> get props => [];
}
