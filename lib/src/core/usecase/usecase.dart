import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

abstract class UseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}

/// usecase when there is no Params
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
