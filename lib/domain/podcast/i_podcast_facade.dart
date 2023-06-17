import 'package:decibel/domain/podcast/podcast_failures.dart';
import 'package:decibel/domain/podcast/podcast_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';

abstract class IPodcastfacade {
  // BehaviorSubject<List<PodcastModel>> getPodcast();

  BehaviorSubject<Either<PodcastFailure, List<PodcastModel>>> getPodcast();
}
