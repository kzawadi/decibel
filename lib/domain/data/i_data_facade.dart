import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IDatafacade {
  Future<Either<DataFailure, Unit>> submitData(User user);
  Future<Either<DataFailure, User>> getUserData();
}
