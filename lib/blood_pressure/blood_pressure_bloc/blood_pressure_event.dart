import "package:equatable/equatable.dart";

abstract class BloodPressureEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateBloodPressure extends BloodPressureEvent {
  final Map<String, dynamic> BloodPressureData;
  CreateBloodPressure({required this.BloodPressureData});
  @override
  List<Object> get props => [BloodPressureData];
}

class Day0BloodPressure extends BloodPressureEvent {}

class GetBloodPressure extends BloodPressureEvent {
  String dayNumber;
  GetBloodPressure({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
