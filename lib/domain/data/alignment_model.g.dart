// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AlignmentModel _$$_AlignmentModelFromJson(Map<String, dynamic> json) =>
    _$_AlignmentModel(
      uid: json['uid'] as String? ?? '',
      partneruid: json['partneruid'] as String?,
      counterPart: json['counterPart'] as String?,
      initiatorUserName: json['initiatorUserName'] as String?,
      initiatoruid: json['initiatoruid'] as String?,
      zodiacSignofInitiator: json['zodiacSignofInitiator'] as String?,
      partnerZodiacSign: json['partnerZodiacSign'] as String?,
      steps: json['steps'] as String? ?? '1',
      started: json['started'] as bool? ?? false,
      accepted: json['accepted'] as bool? ?? false,
      confirmAlign: json['confirmAlign'],
      initialDate:
          const TimestampConverter().fromJson(json['initialDate'] as Timestamp),
    );

Map<String, dynamic> _$$_AlignmentModelToJson(_$_AlignmentModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'partneruid': instance.partneruid,
      'counterPart': instance.counterPart,
      'initiatorUserName': instance.initiatorUserName,
      'initiatoruid': instance.initiatoruid,
      'zodiacSignofInitiator': instance.zodiacSignofInitiator,
      'partnerZodiacSign': instance.partnerZodiacSign,
      'steps': instance.steps,
      'started': instance.started,
      'accepted': instance.accepted,
      'confirmAlign': instance.confirmAlign,
      'initialDate': const TimestampConverter().toJson(instance.initialDate),
    };
