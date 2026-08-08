import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/entities/manga_entity.dart';

part 'explore_state.freezed.dart';

@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState.initial() = _Initial;
  const factory ExploreState.loading() = _Loading;
  const factory ExploreState.loaded(List<MangaEntity> mangaList) = _Loaded;
  const factory ExploreState.error(String message) = _Error;
}
