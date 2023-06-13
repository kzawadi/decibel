import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'alignment_model.freezed.dart';
part 'alignment_model.g.dart';

@freezed
class AlignmentModel with _$AlignmentModel {
  const factory AlignmentModel({
    // String? uid,
    @Default('') String uid,
    String? partneruid,
    String? counterPart,
    String? initiatorUserName,
    String? initiatoruid,
    String? zodiacSignofInitiator,
    String? partnerZodiacSign,
    @Default('1') String steps,
    @Default(false) bool started,
    @Default(false) bool accepted,
    confirmAlign,
    @TimestampConverter() required DateTime initialDate,
  }) = _AlignmentModel;

  factory AlignmentModel.fromJson(Map<String, dynamic> json) =>
      _$AlignmentModelFromJson(json);

  factory AlignmentModel.withId() =>
      AlignmentModel(uid: const Uuid().v4(), initialDate: DateTime.now());
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp value) => value.toDate();

  @override
  Timestamp toJson(DateTime value) => Timestamp.fromDate(value);
}
