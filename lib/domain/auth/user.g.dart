// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String?,
      key: json['key'] as String?,
      email: json['email'] as String?,
      userId: json['userId'] as String?,
      displayName: json['displayName'] as String?,
      userName: json['userName'] as String?,
      zodiacSign: json['zodiacSign'] as String?,
      webSite: json['webSite'] as String?,
      profilePic: json['profilePic'] as String?,
      bannerImage: json['bannerImage'] as String?,
      contact: json['contact'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      dob: json['dob'] as String?,
      createdAt: json['createdAt'] as String?,
      isVerified: json['isVerified'] as bool?,
      followers: json['followers'] as int?,
      following: json['following'] as int?,
      fcmToken: json['fcmToken'] as String?,
      followersList: (json['followersList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followingList: (json['followingList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      userInterests: (json['userInterests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'email': instance.email,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'userName': instance.userName,
      'zodiacSign': instance.zodiacSign,
      'webSite': instance.webSite,
      'profilePic': instance.profilePic,
      'bannerImage': instance.bannerImage,
      'contact': instance.contact,
      'bio': instance.bio,
      'location': instance.location,
      'dob': instance.dob,
      'createdAt': instance.createdAt,
      'isVerified': instance.isVerified,
      'followers': instance.followers,
      'following': instance.following,
      'fcmToken': instance.fcmToken,
      'followersList': instance.followersList,
      'followingList': instance.followingList,
      'userInterests': instance.userInterests,
    };
