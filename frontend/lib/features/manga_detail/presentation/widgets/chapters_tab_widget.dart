import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/chapters_bloc.dart';
import '../bloc/chapters_event.dart';
import '../bloc/chapters_state.dart';
import 'chapter_list_item.dart';

class ChaptersTabWidget extends StatelessWidget {
  final MangaEntity manga;

  const ChaptersTabWidget({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ChaptersBloc, ChaptersState>(
      builder: (context, state) {
        if (state is ChaptersLoading || state is ChaptersInitial) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        } else if (state is ChaptersError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<ChaptersBloc>().add(
                LoadChapters(malId: manga.malId, title: manga.title),
              );
            },
          );
        } else if (state is ChaptersLoaded) {
          final chapters = state.chapters;

          if (chapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد فصول متوفرة حالياً',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header bar with chapter count & sort toggle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingLarge,
                  vertical: AppDimens.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${chapters.length} فصل',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<ChaptersBloc>().add(ToggleSortDirection());
                      },
                      icon: Icon(
                        state.isAscending
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 16,
                      ),
                      label: Text(
                        state.isAscending ? 'تصاعدي' : 'تنازلي',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Chapter list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    top: AppDimens.paddingSmall,
                    bottom: 100.0,
                  ),
                  itemCount: chapters.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 68),
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return ChapterListItem(
                      chapter: chapter,
                      onTap: () {
                        context.push(
                          '/reader/${chapter.id}',
                          extra: {
                            'malId': manga.malId,
                            'chapterTitle':
                                chapter.title ?? chapter.chapterString,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
