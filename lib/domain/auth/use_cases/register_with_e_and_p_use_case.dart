// import 'package:dartz/dartz.dart';
import 'package:decibel/domain/auth/auth_failure.dart';
import 'package:decibel/domain/auth/i_auth_facade.dart';
import 'package:decibel/domain/auth/value_objects.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterWithEmailAndPasswordUseCase {
  RegisterWithEmailAndPasswordUseCase(this._iAuthFacade);

  final IAuthFacade _iAuthFacade;

  Future<Either<AuthFailure, Unit>> call({
    required EmailAddress emailAddress,
    required Password password,
  }) async =>
      _iAuthFacade.registerWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );
}
