import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../bloc/manga_reader_bloc.dart';
import '../bloc/manga_reader_event.dart';
import '../bloc/manga_reader_state.dart';

class MangaReaderPage extends StatelessWidget {
  final String chapterId;

  const MangaReaderPage({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MangaReaderBloc>()..add(LoadChapter(chapterId)),
      child: const _MangaReaderView(),
    );
  }
}

class _MangaReaderView extends StatelessWidget {
  const _MangaReaderView();

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<MangaReaderBloc>(),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'Reading Mode',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                BlocBuilder<MangaReaderBloc, MangaReaderState>(
                  builder: (context, state) {
                    if (state is MangaReaderLoaded) {
                      return Column(
                        children: [
                          // ignore: deprecated_member_use
                          RadioListTile<ReadingMode>(
                            title: const Text('Horizontal (RTL)'),
                            value: ReadingMode.horizontalRtl,
                            // ignore: deprecated_member_use
                            groupValue: state.readingMode,
                            // ignore: deprecated_member_use
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<MangaReaderBloc>()
                                    .add(ChangeReadingMode(value));
                                Navigator.pop(context);
                              }
                            },
                          ),
                          // ignore: deprecated_member_use
                          RadioListTile<ReadingMode>(
                            title: const Text('Vertical (Webtoon)'),
                            value: ReadingMode.verticalWebtoon,
                            // ignore: deprecated_member_use
                            groupValue: state.readingMode,
                            // ignore: deprecated_member_use
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<MangaReaderBloc>()
                                    .add(ChangeReadingMode(value));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MangaReaderBloc, MangaReaderState>(
        listener: (context, state) {
          if (state is MangaReaderLoaded) {
            if (state.isImmersiveMode) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            }
          }
        },
        builder: (context, state) {
          if (state is MangaReaderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MangaReaderError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is MangaReaderLoaded) {
            return Stack(
              children: [
                // Main Content View
                GestureDetector(
                  onTap: () {
                    context.read<MangaReaderBloc>().add(ToggleImmersiveMode());
                  },
                  child: _buildContentView(context, state),
                ),

                // Top Overlay
                if (!state.isImmersiveMode)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                               // Reset SystemUI when exiting reader
                               SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                               Navigator.of(context).pop();
                            }
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () => _showSettingsBottomSheet(context),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom Overlay
                if (!state.isImmersiveMode)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom > 0
                              ? MediaQuery.of(context).padding.bottom
                              : 16,
                          top: 16,
                          left: 16,
                          right: 16),
                      child: Center(
                        child: Text(
                          '${state.currentPage + 1} / ${state.pages.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContentView(BuildContext context, MangaReaderLoaded state) {
    if (state.readingMode == ReadingMode.horizontalRtl) {
      return PageView.builder(
        reverse: true, // RTL swiping
        itemCount: state.pages.length,
        onPageChanged: (index) {
          context.read<MangaReaderBloc>().add(PageChanged(index));
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: state.pages[index],
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
          );
        },
      );
    } else {
      // Vertical Webtoon Mode
      // For simplicity in MVP, we just use a standard list view.
      // In a real app we might use `scrollable_positioned_list` or an intersection observer.
      return ListView.builder(
        itemCount: state.pages.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: state.pages[index],
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    }
  }
}
