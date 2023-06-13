// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:decibel/domain/auth/use_cases/auth_use_cases.dart';
// import 'package:decibel/domain/auth/user.dart';
// import 'package:decibel/domain/core/i_auth_use_cases.dart';
// import 'package:decibel/domain/data/use_cases/get_user_data_use_case.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:injectable/injectable.dart';

// part 'auth_bloc.freezed.dart';
// part 'auth_event.dart';
// part 'auth_state.dart';

// @injectable
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthBloc(
//     this._getSignedInUserUseCase,
//     this._signOutUseCase,
//     this._getUserDataUseCase,
//   ) : super(const AuthState.initial()) {
//     on<AuthEvent>(_authEventshandler);
//   }

//   final GetSignedInUserUseCase _getSignedInUserUseCase;
//   final SignOutUseCase _signOutUseCase;
//   final GetUserDataUseCase _getUserDataUseCase;

//   /// The handler functions which holds the application logic of authenticating
//   /// the [User].
//   FutureOr<void> _authEventshandler(
//     AuthEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     await event.map(
//       authCheckRequested: (e) async {
//         await _getSignedInUserUseCase(NoParams()).then(
//           (value) async {
//             await value.fold(
//               () {
//                 emit(const AuthState.unauthenticated());
//               },
//               (r) async {
//                 await _getUserDataUseCase(NoParams()).then(
//                   (value) {
//                     return emit(
//                       value.fold(
//                         (l) => const AuthState.notOnboarded(),
//                         (r) => const AuthState.authenticated(),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//       signedOut: (e) async {
//         final signOutResponse = await _signOutUseCase.call(NoParams());
//         emit(
//           signOutResponse.fold(
//             (l) => const AuthState.unAuthenticatingFailure(),
//             (_) => const AuthState.unauthenticated(),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decibel/domain/auth/use_cases/auth_use_cases.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:decibel/domain/data/use_cases/get_user_data_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// This BLoC handles all events and states related to the user authentication journey in the app.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Constructs an instance of [AuthBloc].
  ///
  /// [_getSignedInUserUseCase]: The use case for retrieving the signed-in user.
  /// [_signOutUseCase]: The use case for signing out the user.
  /// [_getUserDataUseCase]: The use case for retrieving user data.
  AuthBloc(
    this._getSignedInUserUseCase,
    this._signOutUseCase,
    this._getUserDataUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthEvent>(_authEventHandler);
  }
  final GetSignedInUserUseCase _getSignedInUserUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetUserDataUseCase _getUserDataUseCase;

  /// Handles authentication events and updates the state accordingly.
  FutureOr<void> _authEventHandler(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.map(
      authCheckRequested: (e) async {
        await _getSignedInUserUseCase(NoParams()).then(
          (value) async {
            await value.fold(
              () {
                emit(const AuthState.unauthenticated());
              },
              (r) async {
                await _getUserDataUseCase(NoParams()).then(
                  (value) {
                    return emit(
                      value.fold(
                        (l) => const AuthState.notOnboarded(),
                        (r) => const AuthState.authenticated(),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
      signedOut: (e) async {
        final signOutResponse = await _signOutUseCase.call(NoParams());
        emit(
          signOutResponse.fold(
            (l) => const AuthState.unAuthenticatingFailure(),
            (_) => const AuthState.unauthenticated(),
          ),
        );
      },
    );
  }
}
