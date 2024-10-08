import 'package:fpdart/fpdart.dart';
import 'package:geolocation/core/api/dio/failure.dart';

typedef EitherModel<T> = Future<Either<Failure, T>>; 