import "package:equatable/equatable.dart";

abstract class SnehanaLakshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateSnehanaLakshana extends SnehanaLakshanaEvent {
  final Map<String, dynamic> SnehanaLakshanaData;
  CreateSnehanaLakshana({required this.SnehanaLakshanaData});
  @override
  List<Object> get props => [SnehanaLakshanaData];
}

class Day0SnehanaLakshana extends SnehanaLakshanaEvent {}

class GetSnehanaLakshana extends SnehanaLakshanaEvent {
  String dayNumber;
  GetSnehanaLakshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
