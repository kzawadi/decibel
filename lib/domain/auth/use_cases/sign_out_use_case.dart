// import 'package:dartz/dartz.dart';
import 'package:decibel/domain/auth/auth_failure.dart';
import 'package:decibel/domain/auth/i_auth_facade.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase extends IUseCase<Either<AuthFailure, Unit>, NoParams> {
  SignOutUseCase(this._authFacade);

  final IAuthFacade _authFacade;

  @override
  Future<Either<AuthFailure, Unit>> call(NoParams params) =>
      _authFacade.signOut();
}
