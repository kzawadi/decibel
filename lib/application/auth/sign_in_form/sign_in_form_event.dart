part of 'sign_in_form_bloc.dart';

/// Represents the events that can occur in the sign-in form.
///
/// This class is annotated with `@freezed` to generate the necessary boilerplate code for freezed.
/// Each event is defined as a constructor using the `const factory` syntax.
/// The `@Implements` annotation ensures that the generated class implements the corresponding interface.
///
/// Example usage:
/// ```dart
/// SignInFormEvent event = SignInFormEvent.emailChanged('example@example.com');
/// ```
@freezed

/// Represents the events that can occur in the sign-in form.
///
/// This class is used to define different events that can be triggered in the sign-in form.
/// Each event is represented as a factory constructor with a specific name and optional parameters.
/// The events are defined using the `const factory` syntax.
///
/// Example usage:
/// ```dart
/// SignInFormEvent event = SignInFormEvent.emailChanged('example@example.com');
/// ```
class SignInFormEvent with _$SignInFormEvent {
  /// Represents the event of changing the email in the sign-in form.
  ///
  /// The `emailStr` parameter represents the new email string value.
  const factory SignInFormEvent.emailChanged(String emailStr) = EmailChanged;

  /// Represents the event of changing the password in the sign-in form.
  ///
  /// The `passwordStr` parameter represents the new password string value.
  const factory SignInFormEvent.passwordChanged(String passwordStr) =
      PasswordChanged;

  /// Represents the event of pressing the register button in the sign-in form.
  const factory SignInFormEvent.registerWithEmailAndPasswordPressed() =
      RegisterWithEmailAndPasswordPressed;

  /// Represents the event of pressing the sign-in button in the sign-in form.
  const factory SignInFormEvent.signInWithEmailAndPasswordPressed() =
      SignInWithEmailAndPasswordPressed;

  /// Represents the event of pressing the sign-in with Google button in the sign-in form.
  const factory SignInFormEvent.signInWithGooglePressed() =
      SignInWithGooglePressed;

  /// Represents the event of toggling the visibility of the password field in the sign-in form.
  const factory SignInFormEvent.showPassword() = _ShowPassword;
}
