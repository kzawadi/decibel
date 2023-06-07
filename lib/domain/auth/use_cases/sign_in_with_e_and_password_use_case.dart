// import 'package:dartz/dartz.dart';
import 'package:decibel/domain/auth/auth_failure.dart';
import 'package:decibel/domain/auth/i_auth_facade.dart';
import 'package:decibel/domain/auth/value_objects.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInWithEmailAndPasswordUseCase {
  SignInWithEmailAndPasswordUseCase(this._authFacade);

  final IAuthFacade _authFacade;

  Future<Either<AuthFailure, Unit>> call({
    required EmailAddress emailAddress,
    required Password password,
  }) {
    return _authFacade.signInWithEmailAndPassword(
      emailAddress: emailAddress,
      password: password,
    );
  }
}
