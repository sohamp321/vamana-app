import 'package:equatable/equatable.dart';

abstract class DashBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDashBoardData extends DashBoardEvent {

}

