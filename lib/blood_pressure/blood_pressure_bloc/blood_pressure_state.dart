import 'package:equatable/equatable.dart';

abstract class BloodPressureState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BloodPressureInitial extends BloodPressureState {
  @override
  List<Object> get props => [];
}

class BloodPressureLoading extends BloodPressureState {
  @override
  List<Object> get props => [];
}

class BloodPressureLoaded extends BloodPressureState {
  final Map<String, dynamic>? BloodPressureDataRec;
  BloodPressureLoaded({required this.BloodPressureDataRec});
  @override
  List<Object?> get props => [BloodPressureDataRec];
}

class BloodPressureCreated extends BloodPressureState {
  @override
  List<Object> get props => [];
}

class BloodPressureError extends BloodPressureState {
  final String error;
  BloodPressureError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingBloodPressure extends BloodPressureState {
   @override
  List<Object> get props => [];
}
