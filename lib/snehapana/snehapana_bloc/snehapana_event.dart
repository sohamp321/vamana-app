import "package:equatable/equatable.dart";

abstract class SnehapanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateSnehapana extends SnehapanaEvent {
  final Map<String, dynamic> SnehapanaData;
  CreateSnehapana({required this.SnehapanaData});
  @override
  List<Object> get props => [SnehapanaData];
}

class Day0Snehapana extends SnehapanaEvent {}

class GetSnehapana extends SnehapanaEvent {
  String dayNumber;
  GetSnehapana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
