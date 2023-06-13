import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:decibel/domain/data/use_cases/get_user_data_use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'onboard_bloc.freezed.dart';
part 'onboard_event.dart';
part 'onboard_state.dart';

/// A BLoC (Business Logic Component) responsible for managing the onboarding process.
///
/// This BLoC class handles the onboarding process by listening to [OnboardEvent]s and emitting [OnboardState]s accordingly.
/// It uses the [GetUserDataUseCase] to fetch user data during the onboarding process.
///
/// Example usage:
/// ```dart
/// OnboardBloc bloc = OnboardBloc(getUserDataUseCase);
/// ```
@injectable
class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  /// Creates an instance of [OnboardBloc] with the given [GetUserDataUseCase].
  ///
  /// The [GetUserDataUseCase] is responsible for retrieving user data during the onboarding process.
  OnboardBloc(this._getUserDataUseCase) : super(OnboardState.initial()) {
    on<OnboardEvent>(_onboardingEventHandler);
  }

  final GetUserDataUseCase _getUserDataUseCase;

  /// Handles the [OnboardEvent] and updates the [OnboardState] accordingly.
  ///
  /// This method is invoked when an [OnboardEvent] is emitted. It performs the necessary actions based on the event,
  /// such as retrieving user data using the [GetUserDataUseCase] and updating the state accordingly.
  ///
  /// The [event] parameter represents the current event being handled.
  /// The [emit] parameter is used to emit the new [OnboardState].
  FutureOr<void> _onboardingEventHandler(
    OnboardEvent event,
    Emitter<OnboardState> emit,
  ) async {
    await event.map(
      started: (_) async {
        await _getUserDataUseCase(NoParams()).then(
          (value) {
            emit(
              state.copyWith(
                result: some(value),
              ),
            );
          },
        );
      },
    );
  }
}
