part of 'auth_bloc.dart';

/// Represents the different authentication states that can occur in an application.
///
/// This class is used in conjunction with the `freezed_annotation` package to define a sealed union,
/// allowing for a fixed set of subclasses that `AuthState` can have.
///
/// The subclasses represent the various authentication states:
/// - `Initial`: Represents the initial state of authentication.
/// - `Authenticated`: Represents the state when the user is authenticated.
/// - `Unauthenticated`: Represents the state when the user is not authenticated.
/// - `UnAuthenticatingFailure`: Represents the state when there is a failure during the unauthentication process.
/// - `_notOnboarded`: Represents the state when the user is not onboarded.
///
/// Example usage:
/// ```dart
/// AuthState state = AuthState.initial();
///
/// if (state is Authenticated) {
///   // Handle authenticated state
/// } else if (state is Unauthenticated) {
///   // Handle unauthenticated state
/// }
/// ```
@freezed
class AuthState with _$AuthState {
  /// Represents the initial state of authentication.
  const factory AuthState.initial() = Initial;

  /// Represents the state when the user is authenticated.
  const factory AuthState.authenticated() = Authenticated;

  /// Represents the state when the user is not authenticated.
  const factory AuthState.unauthenticated() = Unauthenticated;

  /// Represents the state when there is a failure during the unauthentication process.
  const factory AuthState.unAuthenticatingFailure() = UnAuthenticatingFailure;

  /// Represents the state when the user is not onboarded.
  const factory AuthState.notOnboarded() = _notOnboarded;
}
