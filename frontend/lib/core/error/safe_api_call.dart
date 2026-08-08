import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'failures.dart';

mixin SafeApiCall {
  Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      final message = e.response?.statusMessage ?? e.message ?? 'Server Connection Error';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
