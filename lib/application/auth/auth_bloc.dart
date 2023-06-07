import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decibel/domain/auth/use_cases/auth_use_cases.dart';
import 'package:decibel/domain/auth/user.dart';
import 'package:decibel/domain/core/i_auth_use_cases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

///This bloc handle all event and state of the apps user authentication journey
// @injectable
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._getSignedInUserUseCase,
    this._signOutUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthEvent>(_authEventshandler);
  }

  final GetSignedInUserUseCase _getSignedInUserUseCase;
  final SignOutUseCase _signOutUseCase;

  /// The handler functions which holds the application logic of authenticating
  /// the [User].
  FutureOr<void> _authEventshandler(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.map(
      authCheckRequested: (e) async {
        await _getSignedInUserUseCase(NoParams()).then(
          (value) async {
            value.fold(
              () {
                emit(const AuthState.unauthenticated());
              },
              (r) {
                emit(
                  const AuthState.authenticated(),
                );

                // await _getUserDataUseCase(NoParams()).then(
                //   (value) {
                //     return emit(
                //       value.fold(
                //         (l) => const AuthState.notOnboarded(),
                //         (r) => const AuthState.authenticated(),
                //       ),
                //     );
                //   },
                // );
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
