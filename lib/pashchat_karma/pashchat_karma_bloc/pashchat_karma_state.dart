import 'package:equatable/equatable.dart';

abstract class PashchatKarmaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PashchatKarmaInitial extends PashchatKarmaState {
  @override
  List<Object> get props => [];
}

class PashchatKarmaLoading extends PashchatKarmaState {
  @override
  List<Object> get props => [];
}

class PashchatKarmaLoaded extends PashchatKarmaState {
  final Map<String, dynamic>? PashchatKarmaDataRec;
  PashchatKarmaLoaded({required this.PashchatKarmaDataRec});
  @override
  List<Object?> get props => [PashchatKarmaDataRec];
}

class PashchatKarmaCreated extends PashchatKarmaState {
  @override
  List<Object> get props => [];
}

class PashchatKarmaError extends PashchatKarmaState {
  final String error;
  PashchatKarmaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingPashchatKarma extends PashchatKarmaState {
   @override
  List<Object> get props => [];
}
