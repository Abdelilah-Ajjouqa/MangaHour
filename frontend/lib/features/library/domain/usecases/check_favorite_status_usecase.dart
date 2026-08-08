import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

@lazySingleton
class CheckFavoriteStatusUseCase implements UseCase<bool, int> {
  final FavoritesRepository repository;

  CheckFavoriteStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.isFavorite(params);
  }
}
