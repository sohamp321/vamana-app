import "package:equatable/equatable.dart";

abstract class RookshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateRookshana extends RookshanaEvent {
  final Map<String, dynamic> RookshanaData;
  CreateRookshana({required this.RookshanaData});
  @override
  List<Object> get props => [RookshanaData];
}

class Day0Rookshana extends RookshanaEvent {}

class GetRookshana extends RookshanaEvent {
  String dayNumber;
  GetRookshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
