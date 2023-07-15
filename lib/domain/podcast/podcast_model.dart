import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_model.freezed.dart';
part 'podcast_model.g.dart';

@freezed
class PodcastModel with _$PodcastModel {
  const factory PodcastModel({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? link,
    String? copyright,
    List<EpisodeModel>? episodes,
    bool? paid,
    AuthorModel? author,
  }) = _PodcastModel;

  factory PodcastModel.fromJson(Map<String, dynamic> json) =>
      _$PodcastModelFromJson(json);
}

@freezed
class EpisodeModel with _$EpisodeModel {
  factory EpisodeModel({
    required String id,
    String? title,
    String? description,
    String? audioUrl,
    DateTime? releaseDate,
    Duration? duration,
    bool? isPaused,
    String? link,
  }) = _EpisodeModel;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);
}

@freezed
class AuthorModel with _$AuthorModel {
  factory AuthorModel({
    required String id,
    String? name,
    String? bio,
    String? imageUrl,
  }) = _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
}
