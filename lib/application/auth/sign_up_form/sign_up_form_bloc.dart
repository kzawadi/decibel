import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decibel/domain/auth/auth_failure.dart';
import 'package:decibel/domain/auth/use_cases/auth_use_cases.dart';
import 'package:decibel/domain/auth/value_objects.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_up_form_bloc.freezed.dart';
part 'sign_up_form_event.dart';
part 'sign_up_form_state.dart';

/// A BLoC (Business Logic Component) responsible for managing the sign-up form state.
///
/// This BLoC handles user interactions with the sign-up form and performs corresponding actions.
/// It maintains the current state of the form and emits new states in response to events.
///
/// Example usage:
/// ```dart
/// final signUpFormBloc = SignUpFormBloc();
///
/// signUpFormBloc.add(SignUpFormEvent.emailChanged('example@example.com'));
/// signUpFormBloc.add(SignUpFormEvent.passwordChanged('password123'));
/// signUpFormBloc.add(SignUpFormEvent.registerWithEmailAndPasswordPressed());
/// ```
@injectable
class SignUpFormBloc extends Bloc<SignUpFormEvent, SignUpFormState> {
  SignUpFormBloc(
    this._signInWithGoogleUseCase,
    this._registerWithEmailAndPasswordUseCase,
    this._signInWithEmailAndPasswordUseCase,
  ) : super(SignUpFormState.initial()) {
    on<SignUpFormEvent>(_signInFormHandler);
  }

  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final RegisterWithEmailAndPasswordUseCase
      _registerWithEmailAndPasswordUseCase;
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;

  /// Handles the sign-up form events and updates the form state accordingly.
  Future<void> _signInFormHandler(
    SignUpFormEvent event,
    Emitter<SignUpFormState> emit,
  ) async {
    await event.map(
      emailChanged: (e) async {
        emit(
          state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      passwordChanged: (e) async {
        emit(
          state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      registerWithEmailAndPasswordPressed: (e) async {
        await _performActionOnAuthFacadeWithEmailAndPassword(
          _registerWithEmailAndPasswordUseCase.call,
          emit,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async {
        await _performActionOnAuthFacadeWithEmailAndPassword(
          _signInWithEmailAndPasswordUseCase.call,
          emit,
        );
      },
      signInWithGooglePressed: (e) async {
        emit(
          state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ),
        );

        final failureOrSuccess =
            await _signInWithGoogleUseCase.call(NoParams());
        emit(
          state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: some(failureOrSuccess),
          ),
        );
      },
    );
  }

  /// Performs an action on the authentication facade using the provided email and password.
  ///
  /// This method is used for registering and signing in with email and password.
  /// It handles the necessary validations and updates the form state accordingly.
  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    }) forwardedCall,
    Emitter<SignUpFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: some(failureOrSuccess!),
      ),
    );
  }
}
