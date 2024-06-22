import 'package:equatable/equatable.dart';

abstract class PradhanKarmaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PradhanKarmaInitial extends PradhanKarmaState {
  @override
  List<Object> get props => [];
}

class PradhanKarmaLoading extends PradhanKarmaState {
  @override
  List<Object> get props => [];
}

class PradhanKarmaLoaded extends PradhanKarmaState {
  final Map<String, dynamic>? PradhanKarmaDataRec;
  PradhanKarmaLoaded({required this.PradhanKarmaDataRec});
  @override
  List<Object?> get props => [PradhanKarmaDataRec];
}

class PradhanKarmaCreated extends PradhanKarmaState {
  @override
  List<Object> get props => [];
}

class PradhanKarmaError extends PradhanKarmaState {
  final String error;
  PradhanKarmaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingPradhanKarma extends PradhanKarmaState {
   @override
  List<Object> get props => [];
}
