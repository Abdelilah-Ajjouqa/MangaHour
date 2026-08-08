import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/entities/manga_entity.dart';
import '../bloc/manga_detail_bloc.dart';
import '../bloc/manga_detail_event.dart';
import '../bloc/manga_detail_state.dart';
import '../widgets/chapters_tab_widget.dart';
import '../widgets/details_tab_widget.dart';

class MangaDetailPage extends StatelessWidget {
  final MangaEntity manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MangaDetailBloc>()..add(LoadMangaDetail(manga.malId)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _buildSliverAppBar(context),
                _buildSliverTabBar(context),
              ];
            },
            body: BlocBuilder<MangaDetailBloc, MangaDetailState>(
              builder: (context, state) {
                if (state is MangaDetailLoading || state is MangaDetailInitial) {
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
                } else if (state is MangaDetailError) {
                  return Center(child: Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.error)));
                } else if (state is MangaDetailLoaded) {
                  return TabBarView(
                    children: [
                      DetailsTabWidget(mangaDetail: state.manga),
                      const ChaptersTabWidget(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          bottomNavigationBar: _buildReadNowButton(context),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    const double expandedHeight = 400.0;
    final double collapsedHeight = kToolbarHeight + MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        BlocBuilder<MangaDetailBloc, MangaDetailState>(
          builder: (context, state) {
            bool isFavorite = false;
            if (state is MangaDetailLoaded) {
              isFavorite = state.isFavorite;
            }
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                context.read<MangaDetailBloc>().add(const ToggleFavorite());
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {},
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double currentHeight = constraints.biggest.height;
          
          // Calculate how much the AppBar has collapsed (0.0 = fully expanded, 1.0 = fully collapsed)
          final double scrollPercentage = ((expandedHeight - currentHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);
          
          // Fade out the cover and foreground details as we scroll up
          final double foregroundOpacity = (1.0 - (scrollPercentage * 1.5)).clamp(0.0, 1.0);
          
          // Fade in the small title on the AppBar when fully collapsed
          final double titleOpacity = scrollPercentage > 0.8 ? ((scrollPercentage - 0.8) * 5).clamp(0.0, 1.0) : 0.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Image without blur
              CachedNetworkImage(
                imageUrl: manga.coverUrl,
                fit: BoxFit.cover,
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5 + (scrollPercentage * 0.3)), // Darken slightly as it collapses
              ),
              // Foreground Content (Cover Card, Title, Author)
              Positioned(
                bottom: 24, // Keep it anchored to the bottom of the expanded space
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: foregroundOpacity,
                  child: Transform.translate(
                    // Move the card up slightly faster than the scroll for a nice effect
                    offset: Offset(0, -scrollPercentage * 50), 
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: manga.coverUrl,
                            height: 200,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            manga.arabicTitle ?? manga.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<MangaDetailBloc, MangaDetailState>(
                          builder: (context, state) {
                            String author = '...';
                            if (state is MangaDetailLoaded) {
                              author = state.manga.author;
                            }
                            return Text(
                              AppLocalizations.of(context)!.authorPrefix(author),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Small Title that appears when collapsed
              Positioned(
                bottom: 16,
                left: 64,
                right: 64,
                child: Opacity(
                  opacity: titleOpacity,
                  child: Text(
                    manga.arabicTitle ?? manga.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverTabBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          tabs: [
            Tab(text: AppLocalizations.of(context)!.detailsTab),
            Tab(text: AppLocalizations.of(context)!.chaptersTab),
          ],
        ),
      ),
    );
  }

  Widget _buildReadNowButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            context.push('/reader/${manga.malId}');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.readNow, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.play_circle_fill),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
