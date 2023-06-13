part of 'sign_up_form_bloc.dart';

// @freezed
// class SignUpFormState with _$SignUpFormState {
//   const factory SignUpFormState({
//     required EmailAddress emailAddress,
//     required Password password,
//     required bool showErrorMessages,
//     required bool isSubmitting,
//     required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
//   }) = _SignUpFormState;

//   factory SignUpFormState.initial() => SignUpFormState(
//         emailAddress: EmailAddress(''),
//         password: Password(''),
//         showErrorMessages: false,
//         isSubmitting: false,
//         authFailureOrSuccessOption: none(),
//       );
// }

/// Represents the state of the sign-up form.
///
/// This class is annotated with `@freezed` and uses the `_$SignUpFormState` mixin
/// to generate code for the sealed union. It defines a constructor and a factory method.
/// The constructor initializes the form state with the provided parameters,
/// and the factory method creates the initial state of the form.
///
/// Example usage:
/// ```dart
/// SignUpFormState state = SignUpFormState.initial();
///
/// print(state.emailAddress); // Prints an empty email address
/// print(state.showErrorMessages); // Prints false
/// ```
@freezed
class SignUpFormState with _$SignUpFormState {
  /// Represents the state of the sign-up form.
  const factory SignUpFormState({
    required EmailAddress emailAddress,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignUpFormState;

  /// Creates the initial state of the sign-up form.
  factory SignUpFormState.initial() => SignUpFormState(
        emailAddress: EmailAddress(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        authFailureOrSuccessOption: none(),
      );
}
