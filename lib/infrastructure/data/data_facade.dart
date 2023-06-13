import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/data/data_failure.dart';
import 'package:decibel/domain/data/i_data_facade.dart';
import 'package:decibel/infrastructure/core/firestore_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_user;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IDatafacade)
class DataServicesFacade implements IDatafacade {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final fire_user.FirebaseAuth _auth = fire_user.FirebaseAuth.instance;

  @override
  Future<Either<DataFailure, User>> getUserData() async {
    // final userCollection = await _firebaseFirestore.userDocument();

    return _firebaseFirestore.userDocument().then(
          (value) => value.get().then((DocumentSnapshot value) {
            if (value.exists) {
              print('Document data: ${value.data()}');

              final userDataFromFirestore =
                  User.fromJson(value.data() as Map<String, dynamic>);
              return right(userDataFromFirestore);
            } else {
              print('Document does not exist on the database');
              return left(const DataFailure.failedToFetchUserData());
            }
            // return null;
          }),
        );
  }

  @override
  Future<Either<DataFailure, Unit>> submitData(User user) async {
    final userCollection = await _firebaseFirestore.userDocument();

    final user0 = user.copyWith(
      createdAt: DateTime.now().toString(),
      userId: _auth.currentUser!.uid,
      email: _auth.currentUser!.email,
      id: _auth.currentUser!.uid,
      profilePic: _auth.currentUser!.photoURL,
    );
    return Either.tryCatch(() {
      userCollection.set(user0.toJson());
      return unit;
    }, (o, s) {
      return DataFailure.failedToSetData(s.toString());
    });
  }
}
