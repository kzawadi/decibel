import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:decibel/domain/data/i_data_facade.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubmitUserDataUsecase extends IUseCase<Either<DataFailure, Unit>, User> {
  SubmitUserDataUsecase(this._iDatafacace);

  final IDatafacade _iDatafacace;

  @override
  Future<Either<DataFailure, Unit>> call(User params) =>
      _iDatafacace.submitData(params);
}
