import "package:equatable/equatable.dart";

abstract class SarvangaLakshanaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateSarvangaLakshana extends SarvangaLakshanaEvent {
  final Map<String, dynamic> SarvangaLakshanaData;
  CreateSarvangaLakshana({required this.SarvangaLakshanaData});
  @override
  List<Object> get props => [SarvangaLakshanaData];
}

class Day0SarvangaLakshana extends SarvangaLakshanaEvent {}

class GetSarvangaLakshana extends SarvangaLakshanaEvent {
  String dayNumber;
  GetSarvangaLakshana({required this.dayNumber});
  @override
  List<Object> get props => [dayNumber];
}
