import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_failure.freezed.dart';

@freezed
class DataFailure with _$DataFailure {
  const factory DataFailure.general() = _general;

  const factory DataFailure.failedToSetData(String error) = _failedToSetData;
  const factory DataFailure.failedToFetchUserData() = _failedToFetchUserData;
  const factory DataFailure.failedToGetUsers() = _failedToGetUsers;
  const factory DataFailure.failedToFetchAlignments([String? msg]) =
      _failedToFetchAlignments;

  const factory DataFailure.failedToAcceptAlignment([String? msg]) =
      _failedToAcceptAlignment;
  const factory DataFailure.failedTogetConfirmedAlignments([String? msg]) =
      _failedTogetConfirmedAlignments;
}
