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

  @override
  List<Object> get props => [];
}