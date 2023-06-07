// import 'package:dartz/dartz.dart';
import 'package:decibel/domain/auth/auth_failure.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/auth/value_objects.dart';
import 'package:fpdart/fpdart.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<Either<AuthFailure, Unit>> signOut();
}
