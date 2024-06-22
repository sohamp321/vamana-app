import "package:equatable/equatable.dart";

abstract class PradhanKarmaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePradhanKarma extends PradhanKarmaEvent {
  final Map<String, dynamic> PradhanKarmaData;
  CreatePradhanKarma({required this.PradhanKarmaData});
  @override
  List<Object> get props => [PradhanKarmaData];
}

class Day0PradhanKarma extends PradhanKarmaEvent {}

class GetPradhanKarma extends PradhanKarmaEvent {
  String dayNumber;
  GetPradhanKarma({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
