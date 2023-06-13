import 'package:fpdart/fpdart.dart';

abstract class NameValidationError {
  NameValidationError(this.message);
  final String message;
}

class NameTooLongError extends NameValidationError {
  NameTooLongError(super.message);
}

class NameTooShortError extends NameValidationError {
  NameTooShortError(super.message);
}

class Name {
  Name._(this.value);
  final String value;

  static Either<NameValidationError, Name> create(String value) {
    if (value.length > 10) {
      return Left(NameTooLongError('Name must be at most 10 characters long'));
    } else if (value.length < 3) {
      return Left(NameTooShortError('Name must be at least 3 characters long'));
    } else {
      return Right(Name._(value));
    }
  }
}





// class User {
//   final String id;
//   final Name name;
//   final String email;

//   User({required this.id, required this.name, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: Name.create(json['name']).fold(
//         (l) => throw l,
//         (r) => r,
//       ),
//       email: json['email'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name.value,
//         'email': email,
//       };
// }