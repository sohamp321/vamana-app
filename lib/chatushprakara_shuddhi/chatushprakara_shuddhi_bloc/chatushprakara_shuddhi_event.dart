import "package:equatable/equatable.dart";

abstract class ChatushprakaraShuddhiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateChatushprakaraShuddhi extends ChatushprakaraShuddhiEvent {
  final Map<String, dynamic> ChatushprakaraShuddhiData;
  CreateChatushprakaraShuddhi({required this.ChatushprakaraShuddhiData});
  @override
  List<Object> get props => [ChatushprakaraShuddhiData];
}

class Day0ChatushprakaraShuddhi extends ChatushprakaraShuddhiEvent {}

class GetChatushprakaraShuddhi extends ChatushprakaraShuddhiEvent {
  String dayNumber;
  GetChatushprakaraShuddhi({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
