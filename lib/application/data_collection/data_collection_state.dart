// part of 'data_collection_bloc.dart';

// @freezed
// class DataCollectionState with _$DataCollectionState {
//   const factory DataCollectionState({
//     required bool loveChecked,
//     required bool friendsChecked,
//     required bool gameSquadChecked,
//     required bool likeMindedChecked,
//     required DateTime dob,
//     required String userName,
//     required UserPreference userPreference,
//     required bool isLoading,
//     required bool onboarded,
//     required Option<Either<DataFailure, Unit>> dataFailureorSucces,
//     required List<String> selectedInterest,
//     required String interest,
//   }) = _DataCollectionState;

//   factory DataCollectionState.initial() => DataCollectionState(
//         loveChecked: false,
//         friendsChecked: false,
//         gameSquadChecked: false,
//         likeMindedChecked: false,
//         dob: DateTime.now(),
//         userName: AppStrings.initialName,
//         userPreference: UserPreference.friendship,
//         isLoading: false,
//         dataFailureorSucces: none(),
//         onboarded: false,
//         selectedInterest: [],
//         interest: 'news',
//       );
// }

part of 'data_collection_bloc.dart';

@freezed
class DataCollectionState with _$DataCollectionState {
  /// Represents the state of data collection.
  ///
  /// This class encapsulates various properties and their states related to data collection.
  const factory DataCollectionState({
    /// Represents whether the "Love" checkbox is checked.
    required bool loveChecked,

    /// Represents whether the "Friends" checkbox is checked.
    required bool friendsChecked,

    /// Represents whether the "Game Squad" checkbox is checked.
    required bool gameSquadChecked,

    /// Represents whether the "Like-minded" checkbox is checked.
    required bool likeMindedChecked,

    /// Represents the date of birth selected by the user.
    required DateTime dob,

    /// Represents the user name entered by the user.
    required String userName,

    /// Represents the loading state of the data collection process.
    required bool isLoading,

    /// Represents whether the user has completed the onboarding process.
    required bool onboarded,

    /// Represents the result of the data collection operation.
    required Option<Either<DataFailure, Unit>> dataFailureorSucces,

    /// Represents the list of selected interests by the user.
    required List<String> selectedInterest,

    /// Represents the current interest selected by the user.
    required String interest,
  }) = _DataCollectionState;

  /// Creates an initial state for data collection.
  factory DataCollectionState.initial() => DataCollectionState(
        loveChecked: false,
        friendsChecked: false,
        gameSquadChecked: false,
        likeMindedChecked: false,
        dob: DateTime.now(),
        userName: AppStrings.initialName,
        isLoading: false,
        dataFailureorSucces: none(),
        onboarded: false,
        selectedInterest: [],
        interest: 'news',
      );
}
