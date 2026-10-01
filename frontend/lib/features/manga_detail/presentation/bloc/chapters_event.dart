import 'package:equatable/equatable.dart';

abstract class ChaptersEvent extends Equatable {
  const ChaptersEvent();

  @override
  List<Object?> get props => [];
}

class LoadChapters extends ChaptersEvent {
  final int malId;
  final String title;

  const LoadChapters({required this.malId, required this.title});

  @override
  List<Object?> get props => [malId, title];
}

class ToggleSortDirection extends ChaptersEvent {}
