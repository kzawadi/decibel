// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:decibel/domain/auth/auth_failure.dart';
// import 'package:decibel/domain/auth/use_cases/auth_use_cases.dart';
// import 'package:decibel/domain/auth/value_objects.dart';
// import 'package:decibel/domain/core/i_auth_use_cases.dart';
// // import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:injectable/injectable.dart';

// part 'sign_in_form_bloc.freezed.dart';
// part 'sign_in_form_event.dart';
// part 'sign_in_form_state.dart';

// @injectable
// class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
//   SignInFormBloc(
//     this._registerWithEmailAndPasswordUseCase,
//     this._signInWithEmailAndPasswordUseCase,
//     this._signInWithGoogleUseCase,
//   ) : super(SignInFormState.initial()) {
//     on<SignInFormEvent>(_signInFormHandler);
//   }

//   final RegisterWithEmailAndPasswordUseCase
//       _registerWithEmailAndPasswordUseCase;
//   final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
//   final SignInWithGoogleUseCase _signInWithGoogleUseCase;

//   FutureOr<void> _signInFormHandler(
//     SignInFormEvent event,
//     Emitter<SignInFormState> emit,
//   ) async {
//     await event.map(
//       emailChanged: (e) async {
//         emit(
//           state.copyWith(
//             emailAddress: EmailAddress(e.emailStr),
//             authFailureOrSuccessOption: none(),
//           ),
//         );
//       },
//       passwordChanged: (e) async {
//         emit(
//           state.copyWith(
//             password: Password(e.passwordStr),
//             authFailureOrSuccessOption: none(),
//           ),
//         );
//       },
//       registerWithEmailAndPasswordPressed: (e) async {
//         await _performActionOnAuthFacadeWithEmailAndPassword(
//           _registerWithEmailAndPasswordUseCase.call,
//           emit,
//         );
//       },
//       signInWithEmailAndPasswordPressed: (e) async {
//         await _performActionOnAuthFacadeWithEmailAndPassword(
//           _signInWithEmailAndPasswordUseCase.call,
//           emit,
//         );
//       },
//       signInWithGooglePressed: (e) async {
//         emit(
//           state.copyWith(
//             isSubmitting: true,
//             authFailureOrSuccessOption: none(),
//           ),
//         );

//         final failureOrSuccess =
//             await _signInWithGoogleUseCase.call(NoParams());
//         emit(
//           state.copyWith(
//             isSubmitting: false,
//             authFailureOrSuccessOption: some(failureOrSuccess),
//           ),
//         );
//       },
//       showPassword: (_) {
//         emit(state.copyWith(showPassword: !state.showPassword));
//       },
//     );
//   }

//   FutureOr<void> _performActionOnAuthFacadeWithEmailAndPassword(
//     Future<Either<AuthFailure, Unit>> Function({
//       required EmailAddress emailAddress,
//       required Password password,
//     }) forwardedCall,
//     Emitter<SignInFormState> emit,
//   ) async {
//     Either<AuthFailure, Unit>? failureOrSuccess;

//     final isEmailValid = state.emailAddress.isValid();
//     final isPasswordValid = state.password.isValid();

//     if (isEmailValid && isPasswordValid) {
//       emit(
//         state.copyWith(
//           isSubmitting: true,
//           authFailureOrSuccessOption: none(),
//         ),
//       );
//       failureOrSuccess = await forwardedCall(
//         emailAddress: state.emailAddress,
//         password: state.password,
//       );
//     }

//     emit(
//       state.copyWith(
//         isSubmitting: false,
//         showErrorMessages: true,
//         authFailureOrSuccessOption: some(failureOrSuccess!),
//       ),
//     );
//   }
// }

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

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

/// A BLoC (Business Logic Component) responsible for managing the state and business logic
/// of the sign-in form.
///
/// This BLoC extends the `Bloc` class from the `bloc` package and handles events of type [SignInFormEvent].
/// It emits states of type [SignInFormState].
///
/// Example usage:
/// ```dart
/// SignInFormBloc bloc = SignInFormBloc(registerUseCase, signInUseCase, signInWithGoogleUseCase);
///
/// bloc.add(SignInFormEvent.emailChanged('example@example.com'));
/// bloc.add(SignInFormEvent.passwordChanged('password'));
/// bloc.add(SignInFormEvent.signInWithEmailAndPasswordPressed());
/// ```
@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  SignInFormBloc(
    this._registerWithEmailAndPasswordUseCase,
    this._signInWithEmailAndPasswordUseCase,
    this._signInWithGoogleUseCase,
  ) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(_signInFormHandler);
  }

  final RegisterWithEmailAndPasswordUseCase
      _registerWithEmailAndPasswordUseCase;
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  /// Handles the incoming [SignInFormEvent] and updates the state accordingly.
  ///
  /// This method is triggered whenever a new [SignInFormEvent] is added to the BLoC.
  /// It uses the [event.map] function to pattern-match on different event types and perform the corresponding actions.
  ///
  /// Example usage:
  /// ```dart
  /// _signInFormHandler(SignInFormEvent.emailChanged('example@example.com'), emit);
  /// ```
  FutureOr<void> _signInFormHandler(
    SignInFormEvent event,
    Emitter<SignInFormState> emit,
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
      showPassword: (_) {
        emit(state.copyWith(showPassword: !state.showPassword));
      },
    );
  }

  /// Performs an action on the authentication facade using the provided forwarded call.
  ///
  /// This method is used to perform common actions related to the authentication facade
  /// such as registration or sign-in with email and password. It takes a `forwardedCall` function
  /// that represents the specific action to be performed on the authentication facade.
  /// The `emit` parameter is used to emit state changes to the BLoC's subscribers.
  ///
  /// Example usage:
  /// ```dart
  /// await _performActionOnAuthFacadeWithEmailAndPassword(
  ///   _registerWithEmailAndPasswordUseCase.call,
  ///   emit,
  /// );
  /// ```
  FutureOr<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    }) forwardedCall,
    Emitter<SignInFormState> emit,
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
