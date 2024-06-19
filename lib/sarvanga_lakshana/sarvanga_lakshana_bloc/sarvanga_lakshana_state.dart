import 'package:equatable/equatable.dart';

abstract class SarvangaLakshanaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SarvangaLakshanaInitial extends SarvangaLakshanaState {
  @override
  List<Object> get props => [];
}

class SarvangaLakshanaLoading extends SarvangaLakshanaState {
  @override
  List<Object> get props => [];
}

class SarvangaLakshanaLoaded extends SarvangaLakshanaState {
  final Map<String, dynamic>? SarvangaLakshanaDataRec;
  SarvangaLakshanaLoaded({required this.SarvangaLakshanaDataRec});
  @override
  List<Object?> get props => [SarvangaLakshanaDataRec];
}

class SarvangaLakshanaCreated extends SarvangaLakshanaState {
  @override
  List<Object> get props => [];
}

class SarvangaLakshanaError extends SarvangaLakshanaState {
  final String error;
  SarvangaLakshanaError({required this.error});
  @override
  List<Object> get props => [error];
}

class CreatingSarvangaLakshana extends SarvangaLakshanaState {
   @override
  List<Object> get props => [];
}
