import "package:equatable/equatable.dart";

abstract class PashchatKarmaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePashchatKarma extends PashchatKarmaEvent {
  final Map<String, dynamic> PashchatKarmaData;
  CreatePashchatKarma({required this.PashchatKarmaData});
  @override
  List<Object> get props => [PashchatKarmaData];
}

class Day0PashchatKarma extends PashchatKarmaEvent {}

class GetPashchatKarma extends PashchatKarmaEvent {
  String dayNumber;
  GetPashchatKarma({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
