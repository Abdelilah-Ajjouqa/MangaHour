import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/widgets/app_horizontal_list.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
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
      backgroundColor: Colors.black, // Dark theme background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('مانجا', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white70),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (state is HomeLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'شائع الآن',
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
                    title: 'الأفضل',
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
                    title: 'تصنيفات',
                    onViewAll: () {},
                  ),
                ),
                const SliverToBoxAdapter(
                  child: GenresCarousel(),
                ),
                const SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'مقترحات لك',
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HomeBloc>().add(LoadHomeData()),
                    child: const Text('إعادة المحاولة'), // Retry
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
