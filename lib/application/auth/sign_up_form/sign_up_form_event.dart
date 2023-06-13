part of 'sign_up_form_bloc.dart';

/// Represents the different events that can occur in the sign-up form.
///
/// This class is annotated with `@freezed` and uses the `_$SignUpFormEvent` mixin
/// to generate code for the sealed union. It defines factory constructors for each event.
///
/// Example usage:
/// ```dart
/// SignUpFormEvent event = SignUpFormEvent.emailChanged('example@example.com');
///
/// if (event is EmailChanged) {
///   // Handle email changed event
/// } else if (event is PasswordChanged) {
///   // Handle password changed event
/// }
/// ```
@freezed
class SignUpFormEvent with _$SignUpFormEvent {
  /// Represents the event when the email is changed in the sign-up form.
  const factory SignUpFormEvent.emailChanged(String emailStr) = EmailChanged;

  /// Represents the event when the password is changed in the sign-up form.
  const factory SignUpFormEvent.passwordChanged(String passwordStr) =
      PasswordChanged;

  /// Represents the event when the user presses the "Register with Email and Password" button.
  const factory SignUpFormEvent.registerWithEmailAndPasswordPressed() =
      RegisterWithEmailAndPasswordPressed;

  /// Represents the event when the user presses the "Sign In with Email and Password" button.
  const factory SignUpFormEvent.signInWithEmailAndPasswordPressed() =
      SignInWithEmailAndPasswordPressed;

  /// Represents the event when the user presses the "Sign In with Google" button.
  const factory SignUpFormEvent.signInWithGooglePressed() =
      SignInWithGooglePressed;
}
