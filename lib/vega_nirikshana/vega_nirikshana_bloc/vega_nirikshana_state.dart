import 'package:equatable/equatable.dart';

abstract class VegaNirikshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VegaNirikshanaInitial extends VegaNirikshanaState {
  @override
  List<Object> get props => [];
}

class VegaNirikshanaLoading extends VegaNirikshanaState {
  @override
  List<Object> get props => [];
}

class VegaNirikshanaLoaded extends VegaNirikshanaState {
  final Map<String, dynamic>? VegaNirikshanaDataRec;
  VegaNirikshanaLoaded({required this.VegaNirikshanaDataRec});
  @override
  List<Object?> get props => [VegaNirikshanaDataRec];
}

class VegaNirikshanaCreated extends VegaNirikshanaState {
  @override
  List<Object> get props => [];
}

class VegaNirikshanaError extends VegaNirikshanaState {
  final String error;
  VegaNirikshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingVegaNirikshana extends VegaNirikshanaState {
   @override
  List<Object> get props => [];
}
