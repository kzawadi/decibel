import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:decibel/domain/data/use_cases/submit_user_data_use_case.dart';
import 'package:decibel/presentation/core/app_strings.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'data_collection_bloc.freezed.dart';
part 'data_collection_event.dart';
part 'data_collection_state.dart';

/// This class represents a BLoC (Business Logic Component) for data collection.
///
/// The [DataCollectionBloc] extends the [Bloc] class from the `bloc` package,
/// which provides the necessary infrastructure for managing state and handling events.
///
/// This BLoC is responsible for collecting user data, such as name, date of birth,
/// user preferences, and interests. It interacts with the corresponding use cases
/// ([SubmitUserDataUsecase] and [SelectInterestsUseCase]) to process and submit the data.
///
/// To use this BLoC, instantiate it and provide the necessary use case dependencies.
/// Then, listen to the state changes using a `StreamBuilder` or similar mechanism.
///
/// Example:
/// ```dart
/// final bloc = DataCollectionBloc(
///   SubmitUserDataUseCase(),
///   SelectInterestsUseCase(),
/// );
///
/// final streamBuilder = StreamBuilder<DataCollectionState>(
///   stream: bloc.stream,
///   builder: (context, snapshot) {
///     // Handle different state conditions
///     if (snapshot.hasData) {
///       // Render UI based on the current state
///     } else if (snapshot.hasError) {
///       // Handle error case
///     } else {
///       // Show loading state
///     }
///   },
/// );
/// ```
@injectable
class DataCollectionBloc
    extends Bloc<DataCollectionEvent, DataCollectionState> {
  DataCollectionBloc(
    this._submitUserDataUsecase,
  ) : super(DataCollectionState.initial()) {
    // Register event handlers
    on<DataCollectionEvent>(_dataCollectionEventHandler);
  }

  final SubmitUserDataUsecase _submitUserDataUsecase;

  /// Event handler for data collection events.
  ///
  /// This method is called whenever a new event is dispatched to the BLoC.
  /// It processes the event and updates the state accordingly using the [emit] function.
  FutureOr<void> _dataCollectionEventHandler(
    DataCollectionEvent event,
    Emitter<DataCollectionState> emit,
  ) async {
    await event.map(
      started: (started) {
        // Handle the "started" event
        // No state update is required in this case
      },
      setName: (value) {
        // Handle the "setName" event
        emit(state.copyWith(userName: value.userName));
      },
      dob: (value) {
        // Handle the "dob" event
        emit(state.copyWith(dob: value.dob!));
      },
      selectPreference: (_selectPreference value) async {
        // Handle the "selectPreference" event
        // emit(
        //   state.copyWith(
        //     userPreference: value.userPreference,
        //   ),
        // );
      },
      submit: (_submit value) async {
        // Handle the "submit" event
        emit(state.copyWith(isLoading: true));
        await _submitUserDataUsecase(
          User(
            displayName: state.userName,
            dob: state.dob.toString(),
            userInterests: state.selectedInterest,
            // userPreference: state.userPreference,
          ),
        ).then(
          (value) => emit(
            state.copyWith(
              dataFailureorSucces: some(value),
              isLoading: false,
            ),
          ),
        );
      },
      selectInterest: (value) async {
        // Handle the "selectInterest" event
        emit(state.copyWith(interest: value.interest));
      },
    );
  }

  /// Handles the selection of user interests.
  ///
  /// This method is called when the "selectInterest" event is received.
  /// It uses the [forwardedCall] function to retrieve the selected interests
  /// based on the current state's interest parameter.
  ///
  /// The selected interests are then updated in the state.
  Future<void> _handleInterest(
    FutureOr<List<String>> Function({
      required String params,
    }) forwardedCall,
    Emitter<DataCollectionState> emit,
  ) async {
    final results = await forwardedCall(params: state.interest);

    emit(state.copyWith(selectedInterest: results));
  }
}
