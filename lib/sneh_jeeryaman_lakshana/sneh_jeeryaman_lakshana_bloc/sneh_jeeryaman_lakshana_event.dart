import "package:equatable/equatable.dart";

abstract class SnehJeeryamanLakshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateSnehJeeryamanLakshana extends SnehJeeryamanLakshanaEvent {
  final Map<String, dynamic> SnehJeeryamanLakshanaData;
  CreateSnehJeeryamanLakshana({required this.SnehJeeryamanLakshanaData});
  @override
  List<Object> get props => [SnehJeeryamanLakshanaData];
}

class Day0SnehJeeryamanLakshana extends SnehJeeryamanLakshanaEvent {}

class GetSnehJeeryamanLakshana extends SnehJeeryamanLakshanaEvent {
  String dayNumber;
  GetSnehJeeryamanLakshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
