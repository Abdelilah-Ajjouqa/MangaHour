import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/manga_cover_image.dart';

import '../../../../core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/injection.dart';
import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import '../../../home/presentation/widgets/offline_dashboard_widget.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 0, // Removes the large empty title space
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.favoritesTab), // Favorites
              Tab(text: AppLocalizations.of(context)!.downloadsTab), // Downloads
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => getIt<LibraryBloc>()..add(LoadLibraryData()),
          child: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if (state is LibraryLoading) {
                return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
              } else if (state is LibraryError) {
                return Center(child: Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.error)));
              } else if (state is LibraryLoaded) {
                return TabBarView(
                  children: [
                    // Favorites Tab (Real Data)
                    state.favorites.isEmpty
                        ? const Center(child: Text('لا توجد مفضلة بعد'))
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: state.favorites.length,
                            itemBuilder: (context, index) {
                              final manga = state.favorites[index];
                              return GestureDetector(
                                onTap: () => context.push('/manga/${manga.malId}', extra: manga).then((_) {
                                  if (!context.mounted) return;
                                  // Reload when returning in case it was unfavorited
                                  context.read<LibraryBloc>().add(LoadLibraryData());
                                }),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: MangaCoverImage(imageUrl: manga.coverUrl),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      manga.arabicTitle ?? manga.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    // Downloads Tab
                    OfflineDashboardWidget(installedManga: state.offlineManga),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
