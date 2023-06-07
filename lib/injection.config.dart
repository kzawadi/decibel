// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i6;
import 'package:injectable/injectable.dart' as _i2;

import 'application/auth/auth_bloc.dart' as _i18;
import 'application/auth/sign_in_form/sign_in_form_bloc.dart' as _i17;
import 'application/auth/sign_up_form/sign_up_form_bloc.dart' as _i13;
import 'application/theme/theme_cubit.dart' as _i15;
import 'domain/auth/i_auth_facade.dart' as _i7;
import 'domain/auth/use_cases/auth_use_cases.dart' as _i14;
import 'domain/auth/use_cases/get_signed_in_user_use_case.dart' as _i16;
import 'domain/auth/use_cases/register_with_e_and_p_use_case.dart' as _i9;
import 'domain/auth/use_cases/sign_in_with_e_and_password_use_case.dart'
    as _i10;
import 'domain/auth/use_cases/sign_in_with_google_use_case.dart' as _i11;
import 'domain/auth/use_cases/sign_out_use_case.dart' as _i12;
import 'infrastructure/auth/firebase_auth_facade.dart' as _i8;
import 'infrastructure/core/analytics.dart' as _i3;
import 'infrastructure/core/firebase_injectable_module.dart' as _i19;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    gh.lazySingleton<_i3.AnalyticsService>(() => _i3.AnalyticsService());
    gh.lazySingleton<_i4.FirebaseAuth>(
        () => firebaseInjectableModule.firebaseAuth);
    gh.lazySingleton<_i5.FirebaseFirestore>(
        () => firebaseInjectableModule.firestore);
    gh.lazySingleton<_i6.GoogleSignIn>(
        () => firebaseInjectableModule.googleSignIn);
    gh.lazySingleton<_i7.IAuthFacade>(() => _i8.FirebaseAuthFacade(
          gh<_i4.FirebaseAuth>(),
          gh<_i6.GoogleSignIn>(),
        ));
    gh.factory<_i9.RegisterWithEmailAndPasswordUseCase>(
        () => _i9.RegisterWithEmailAndPasswordUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i10.SignInWithEmailAndPasswordUseCase>(
        () => _i10.SignInWithEmailAndPasswordUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i11.SignInWithGoogleUseCase>(
        () => _i11.SignInWithGoogleUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i12.SignOutUseCase>(
        () => _i12.SignOutUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i13.SignUpFormBloc>(() => _i13.SignUpFormBloc(
          gh<_i14.SignInWithGoogleUseCase>(),
          gh<_i14.RegisterWithEmailAndPasswordUseCase>(),
          gh<_i14.SignInWithEmailAndPasswordUseCase>(),
        ));
    gh.factory<_i15.ThemeCubit>(() => _i15.ThemeCubit());
    gh.factory<_i16.GetSignedInUserUseCase>(
        () => _i16.GetSignedInUserUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i17.SignInFormBloc>(() => _i17.SignInFormBloc(
          gh<_i14.RegisterWithEmailAndPasswordUseCase>(),
          gh<_i14.SignInWithEmailAndPasswordUseCase>(),
          gh<_i14.SignInWithGoogleUseCase>(),
        ));
    gh.factory<_i18.AuthBloc>(() => _i18.AuthBloc(
          gh<_i14.GetSignedInUserUseCase>(),
          gh<_i14.SignOutUseCase>(),
        ));
    return this;
  }
}

class _$FirebaseInjectableModule extends _i19.FirebaseInjectableModule {}
