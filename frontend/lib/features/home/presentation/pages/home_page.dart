import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/widgets/app_horizontal_list.dart';

import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_shimmer.dart';
import '../widgets/genres_carousel.dart';
import '../widgets/popular_manga_card.dart';
import '../widgets/trending_manga_card.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dark theme background
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const HomeShimmer();
          } else if (state is HomeLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppLocalizations.of(context)!.trendingNow,
                    onViewAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: AppHorizontalList(
                    items: state.trendingManga,
                    height: 280,
                    itemBuilder: (context, manga, index) => TrendingMangaCard(manga: manga),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppLocalizations.of(context)!.best,
                    onViewAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: AppHorizontalList(
                    items: state.popularManga,
                    height: 220,
                    itemBuilder: (context, manga, index) => SizedBox(
                      width: 120,
                      child: PopularMangaCard(manga: manga, index: index),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppLocalizations.of(context)!.genres,
                    onViewAll: () {},
                  ),
                ),
                const SliverToBoxAdapter(
                  child: GenresCarousel(),
                ),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppLocalizations.of(context)!.recommendedForYou,
                  ),
                ),
                SliverToBoxAdapter(
                  child: AppHorizontalList(
                    items: state.popularManga.reversed.toList(),
                    height: 280,
                    itemBuilder: (context, manga, index) => TrendingMangaCard(manga: manga),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24.0)),
              ],
            );
          } else if (state is HomeError) {
            return ErrorRetryWidget(
              message: state.message,
              onRetry: () => context.read<HomeBloc>().add(LoadHomeData()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      ),
    );
  }
}
