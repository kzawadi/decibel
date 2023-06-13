import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:decibel/domain/data/i_data_facade.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserDataUseCase extends IUseCase<Either<DataFailure, User>, NoParams> {
  GetUserDataUseCase(this._iDatafacade);

  final IDatafacade _iDatafacade;

  @override
  Future<Either<DataFailure, User>> call(NoParams params) =>
      _iDatafacade.getUserData();
}
