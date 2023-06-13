part of 'onboard_bloc.dart';

/// Represents the state of the onboarding process.
///
/// This state class defines the different states that the onboarding process can be in.
/// It includes the information about whether the onboarding is complete or not, and the result of the data operation.
///
/// The state is annotated with `@freezed` to indicate that it is part of a freezed union.
///
/// Example usage:
/// ```dart
/// OnboardState state = OnboardState.initial();
/// ```
@freezed
class OnboardState with _$OnboardState {
  /// Creates an instance of [OnboardState] with the given parameters.
  ///
  /// The [onboarded] parameter indicates whether the onboarding process is complete or not.
  /// The [result] parameter represents the result of the data operation, wrapped in an [Option].
  const factory OnboardState({
    required bool onboarded,
    required Option<Either<DataFailure, User>> result,
  }) = _OnboardState;

  /// Creates the initial state of the onboarding process.
  ///
  /// This factory constructor creates an instance of [OnboardState] with the initial values.
  /// The onboarding process is not complete, and the result is set to [none()].
  factory OnboardState.initial() => OnboardState(
        onboarded: false,
        result: none(),
      );
}
