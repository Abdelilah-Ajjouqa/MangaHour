import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;

  const PaginationParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}
