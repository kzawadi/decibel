import 'package:decibel/domain/core/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    String? id,
    String? key,
    String? email,
    String? userId,
    String? displayName,
    String? userName,
    String? zodiacSign,
    String? webSite,
    String? profilePic,
    String? bannerImage,
    String? contact,
    String? bio,
    String? location,
    String? dob,
    String? createdAt,
    bool? isVerified,
    int? followers,
    int? following,
    String? fcmToken,
    UserPreference? userPreference,
    List<String>? followersList,
    List<String>? followingList,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
