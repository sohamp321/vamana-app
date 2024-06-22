import 'package:equatable/equatable.dart';

abstract class ChatushprakaraShuddhiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatushprakaraShuddhiInitial extends ChatushprakaraShuddhiState {
  @override
  List<Object> get props => [];
}

class ChatushprakaraShuddhiLoading extends ChatushprakaraShuddhiState {
  @override
  List<Object> get props => [];
}

class ChatushprakaraShuddhiLoaded extends ChatushprakaraShuddhiState {
  final Map<String, dynamic>? ChatushprakaraShuddhiDataRec;
  ChatushprakaraShuddhiLoaded({required this.ChatushprakaraShuddhiDataRec});
  @override
  List<Object?> get props => [ChatushprakaraShuddhiDataRec];
}

class ChatushprakaraShuddhiCreated extends ChatushprakaraShuddhiState {
  @override
  List<Object> get props => [];
}

class ChatushprakaraShuddhiError extends ChatushprakaraShuddhiState {
  final String error;
  ChatushprakaraShuddhiError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingChatushprakaraShuddhi extends ChatushprakaraShuddhiState {
  @override
  List<Object> get props => [];
}
