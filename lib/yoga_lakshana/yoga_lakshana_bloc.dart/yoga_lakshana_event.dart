import "package:equatable/equatable.dart";

abstract class YogaLakshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateYogaLakshana extends YogaLakshanaEvent {
  final Map<String, dynamic> YogaLakshanaData;
  CreateYogaLakshana({required this.YogaLakshanaData});
  @override
  List<Object> get props => [YogaLakshanaData];
}

class Day0YogaLakshana extends YogaLakshanaEvent {}

class GetYogaLakshana extends YogaLakshanaEvent {
  String dayNumber;
  GetYogaLakshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}