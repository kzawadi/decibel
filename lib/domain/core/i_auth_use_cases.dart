import 'dart:async';

import 'package:equatable/equatable.dart';

// Parameters have to be put into a container object so that they can be
// included in this abstract base class method definition.
// ignore: one_member_abstracts

/// {@template equatable}
/// A base class to facilitate [operator ==] and [hashCode] overrides.
///
/// ```dart
/// @injectable
/// class FooUseCase extends IUseCase<t,Params> {

/// }
/// ```
/// {@endtemplate}
abstract class IUseCase<T, Params> {
  // TODO(kzawadi): remember to inject this class to locator using {@injectable}

  FutureOr<T> call(Params params);
}

// This will be used by the code calling the use case whenever the use case
// doesn't accept any parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
