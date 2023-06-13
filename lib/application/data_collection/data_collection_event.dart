// part of 'data_collection_bloc.dart';

// @freezed
// class DataCollectionEvent with _$DataCollectionEvent {
//   const factory DataCollectionEvent.started() = _Started;

//   const factory DataCollectionEvent.setName(String userName) = _setName;

//   const factory DataCollectionEvent.dob(DateTime? dob) = _dob;

//   const factory DataCollectionEvent.selectPreference(
//     UserPreference userPreference,
//   ) = _selectPreference;

//   const factory DataCollectionEvent.selectInterest(String interest) =
//       _selectInterest;

//   const factory DataCollectionEvent.submit() = _submit;
// }

part of 'data_collection_bloc.dart';

@freezed
class DataCollectionEvent with _$DataCollectionEvent {
  /// Represents the event of starting the data collection process.
  const factory DataCollectionEvent.started() = _Started;

  /// Represents the event of setting the user name.
  ///
  /// [userName]: The name entered by the user.
  const factory DataCollectionEvent.setName(String userName) = _setName;

  /// Represents the event of selecting the date of birth.
  ///
  /// [dob]: The date of birth selected by the user.
  const factory DataCollectionEvent.dob(DateTime? dob) = _dob;

  /// Represents the event of selecting the user preference.
  ///
  /// [userPreference]: The user preference selected by the user.
  const factory DataCollectionEvent.selectPreference() = _selectPreference;

  /// Represents the event of selecting an interest.
  ///
  /// [interest]: The interest selected by the user.
  const factory DataCollectionEvent.selectInterest(String interest) =
      _selectInterest;

  /// Represents the event of submitting the data collection form.
  const factory DataCollectionEvent.submit() = _submit;
}
