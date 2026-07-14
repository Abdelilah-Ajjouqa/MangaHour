import 'package:flutter/material.dart';
import '../../../../app/di/injection.dart';
import '../../../home/domain/usecases/get_offline_manga_usecase.dart';
import '../../../home/domain/entities/manga_entity.dart';
import '../../../home/presentation/widgets/offline_dashboard_widget.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0, // Removes the large empty title space
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'المفضلة'), // Favorites
              Tab(text: 'تنزيلاتي'), // Downloads
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Favorites Tab (Placeholder for now)
            const Center(
              child: Text('قريباً...', style: TextStyle(color: Colors.white70, fontSize: 20)),
            ),
            // Downloads Tab
            FutureBuilder<List<MangaEntity>>(
              future: getIt<GetOfflineMangaUseCase>().call(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }
                
                final installedManga = snapshot.data ?? [];
                return OfflineDashboardWidget(installedManga: installedManga);
              },
            ),
          ],
        ),
      ),
    );
  }
}
