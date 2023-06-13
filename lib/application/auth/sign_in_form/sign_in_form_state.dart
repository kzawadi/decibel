part of 'sign_in_form_bloc.dart';

@freezed

/// Represents the state of the sign-in form.
///
/// This class defines the state of the sign-in form, including the email address, password,
/// error messages visibility, submission status, password visibility, and authentication failure or success option.
/// The state is defined as a constructor with named parameters.
///
/// Example usage:
/// ```dart
/// SignInFormState state = SignInFormState.initial();
/// ```
class SignInFormState with _$SignInFormState {
  /// Creates an instance of [SignInFormState] with the given parameters.
  ///
  /// The [emailAddress] parameter represents the email address entered in the sign-in form.
  ///
  /// The [password] parameter represents the password entered in the sign-in form.
  ///
  /// The [showErrorMessages] parameter indicates whether error messages should be displayed in the form.
  ///
  /// The [isSubmitting] parameter indicates whether the form is currently being submitted.
  ///
  /// The [showPassword] parameter indicates whether the password field should be displayed in plaintext.
  ///
  /// The [authFailureOrSuccessOption] parameter represents the option containing either an authentication failure or success.
  const factory SignInFormState({
    required EmailAddress emailAddress,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool showPassword,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignInFormState;

  /// Creates an initial instance of [SignInFormState].
  ///
  /// The initial state has empty email and password fields, does not show error messages,
  /// is not submitting, has no authentication failure or success, and does not show the password field in plaintext.
  factory SignInFormState.initial() => SignInFormState(
        emailAddress: EmailAddress(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        authFailureOrSuccessOption: none(),
        showPassword: false,
      );
}
