import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

abstract class UseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}

/// Parameters for a use case that requires no input.
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
