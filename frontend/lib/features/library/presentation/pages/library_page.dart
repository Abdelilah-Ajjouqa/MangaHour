import 'package:flutter/material.dart';

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
        body: TabBarView(
          children: [
            // Favorites Tab (Placeholder for now)
            Center(
              child: Text(AppLocalizations.of(context)!.comingSoon, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              )),
            ),
            BlocProvider(
              create: (context) => getIt<LibraryBloc>()..add(LoadOfflineManga()),
              child: BlocBuilder<LibraryBloc, LibraryState>(
                builder: (context, state) {
                  if (state is LibraryLoading) {
                    return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
                  } else if (state is LibraryLoaded) {
                    return OfflineDashboardWidget(installedManga: state.offlineManga);
                  } else if (state is LibraryError) {
                    return Center(child: Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.error)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
