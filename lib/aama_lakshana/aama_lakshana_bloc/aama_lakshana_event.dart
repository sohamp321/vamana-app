import "package:equatable/equatable.dart";

abstract class AamaLakshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateAamaLakshana extends AamaLakshanaEvent {
  final Map<String, dynamic> aamaLakshanaData;
  CreateAamaLakshana({required this.aamaLakshanaData});
  @override
  List<Object> get props => [aamaLakshanaData];
}

class GetAamaLakshana extends AamaLakshanaEvent {

  String dayNumber;
  GetAamaLakshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}