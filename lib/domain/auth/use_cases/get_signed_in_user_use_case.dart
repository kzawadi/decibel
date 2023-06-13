// import 'package:dartz/dartz.dart';
import 'package:decibel/domain/auth/i_auth_facade.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSignedInUserUseCase extends IUseCase<Option<User>, NoParams> {
  GetSignedInUserUseCase(this._iAuthFacade);

  final IAuthFacade _iAuthFacade;

  @override
  Future<Option<User>> call(NoParams params) => _iAuthFacade.getSignedInUser();
}
