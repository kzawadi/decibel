// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PodcastModel _$$_PodcastModelFromJson(Map<String, dynamic> json) =>
    _$_PodcastModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      link: json['link'] as String?,
      copyright: json['copyright'] as String?,
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paid: json['paid'] as bool?,
      author: json['author'] == null
          ? null
          : AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PodcastModelToJson(_$_PodcastModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'link': instance.link,
      'copyright': instance.copyright,
      'episodes': instance.episodes,
      'paid': instance.paid,
      'author': instance.author,
    };

_$_EpisodeModel _$$_EpisodeModelFromJson(Map<String, dynamic> json) =>
    _$_EpisodeModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      audioUrl: json['audioUrl'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
      isPaused: json['isPaused'] as bool?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$$_EpisodeModelToJson(_$_EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'audioUrl': instance.audioUrl,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'isPaused': instance.isPaused,
      'link': instance.link,
    };

_$_AuthorModel _$$_AuthorModelFromJson(Map<String, dynamic> json) =>
    _$_AuthorModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$_AuthorModelToJson(_$_AuthorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'imageUrl': instance.imageUrl,
    };
