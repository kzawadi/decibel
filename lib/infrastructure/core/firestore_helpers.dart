import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decibel/domain/auth/use_cases/get_signed_in_user_use_case.dart';
import 'package:decibel/domain/core/errors.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:decibel/injection.dart';
import 'package:fpdart/fpdart.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<GetSignedInUserUseCase>()(NoParams());
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    print(user);
    return FirebaseFirestore.instance.collection('users').doc(user.id);
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('ongoingAlignments');
}

extension UsersCollectionReferenceX on DocumentReference {
  CollectionReference get usersCollection => collection('users');
}
