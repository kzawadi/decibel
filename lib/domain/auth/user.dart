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
    String? role,
    String? group,
    String? location,
    String? dob,
    String? createdAt,
    bool? isVerified,
    int? followers,
    int? following,
    String? fcmToken,
    List<String>? followersList,
    List<String>? followingList,
    List<String>? userInterests,
    List<String>? purchasedEpisodeIds,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
