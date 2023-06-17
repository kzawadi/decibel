import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decibel/domain/podcast/i_podcast_facade.dart';
import 'package:decibel/domain/podcast/podcast_failures.dart';
import 'package:decibel/domain/podcast/podcast_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: IPodcastfacade)
class Podcastfacade implements IPodcastfacade {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('podcasts');
  @override
  BehaviorSubject<Either<PodcastFailure, List<PodcastModel>>> getPodcast() {
    final subject =
        BehaviorSubject<Either<PodcastFailure, List<PodcastModel>>>();

    _collectionReference.snapshots().listen((snapshot) {
      try {
        final podcasts = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // data['id'] = doc.id;
          return PodcastModel.fromJson(data);
        }).toList();

        subject.add(right(podcasts));
      } catch (e) {
        subject
            .add(left(PodcastFailure.failedToFetchPodcastData(e.toString())));
      }
    });

    return subject;
  }
}
