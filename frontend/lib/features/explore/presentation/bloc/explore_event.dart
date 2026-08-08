import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_event.freezed.dart';

@freezed
class ExploreEvent with _$ExploreEvent {
  const factory ExploreEvent.searchQueryChanged(String query) = _SearchQueryChanged;
  const factory ExploreEvent.genreFilterChanged(String genre) = _GenreFilterChanged;
}
