import "package:equatable/equatable.dart";

abstract class VegaNirikshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateVegaNirikshana extends VegaNirikshanaEvent {
  final Map<String, dynamic> VegaNirikshanaData;
  CreateVegaNirikshana({required this.VegaNirikshanaData});
  @override
  List<Object> get props => [VegaNirikshanaData];
}

class Day0VegaNirikshana extends VegaNirikshanaEvent {}

class GetVegaNirikshana extends VegaNirikshanaEvent {
  String dayNumber;
  GetVegaNirikshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
