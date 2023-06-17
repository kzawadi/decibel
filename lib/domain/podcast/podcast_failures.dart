import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_failures.freezed.dart';

@freezed
class PodcastFailure with _$PodcastFailure {
  const factory PodcastFailure.general() = _general;

  const factory PodcastFailure.failedToFetchPodcastData(String msg) =
      _failedToFetchPodcastData;
}
