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

import 'application/auth/auth_bloc.dart' as _i26;
import 'application/auth/sign_in_form/sign_in_form_bloc.dart' as _i25;
import 'application/auth/sign_up_form/sign_up_form_bloc.dart' as _i18;
import 'application/data_collection/bloc/onboard_bloc.dart' as _i24;
import 'application/data_collection/data_collection_bloc.dart' as _i21;
import 'domain/auth/i_auth_facade.dart' as _i7;
import 'domain/auth/use_cases/auth_use_cases.dart' as _i19;
import 'domain/auth/use_cases/get_signed_in_user_use_case.dart' as _i22;
import 'domain/auth/use_cases/register_with_e_and_p_use_case.dart' as _i13;
import 'domain/auth/use_cases/sign_in_with_e_and_password_use_case.dart'
    as _i15;
import 'domain/auth/use_cases/sign_in_with_google_use_case.dart' as _i16;
import 'domain/auth/use_cases/sign_out_use_case.dart' as _i17;
import 'domain/data/i_data_facade.dart' as _i9;
import 'domain/data/use_cases/get_user_data_use_case.dart' as _i23;
import 'domain/data/use_cases/select_interests_use_case.dart' as _i14;
import 'domain/data/use_cases/submit_user_data_use_case.dart' as _i20;
import 'domain/podcast/i_podcast_facade.dart' as _i11;
import 'infrastructure/auth/firebase_auth_facade.dart' as _i8;
import 'infrastructure/core/analytics.dart' as _i3;
import 'infrastructure/core/firebase_injectable_module.dart' as _i27;
import 'infrastructure/data/data_facade.dart' as _i10;
import 'infrastructure/podcast/podcast_facade.dart' as _i12;

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
    gh.lazySingleton<_i9.IDatafacade>(() => _i10.DataServicesFacade());
    gh.lazySingleton<_i11.IPodcastfacade>(() => _i12.Podcastfacade());
    gh.factory<_i13.RegisterWithEmailAndPasswordUseCase>(
        () => _i13.RegisterWithEmailAndPasswordUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i14.SelectInterestsUseCase>(
        () => _i14.SelectInterestsUseCase());
    gh.factory<_i15.SignInWithEmailAndPasswordUseCase>(
        () => _i15.SignInWithEmailAndPasswordUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i16.SignInWithGoogleUseCase>(
        () => _i16.SignInWithGoogleUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i17.SignOutUseCase>(
        () => _i17.SignOutUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i18.SignUpFormBloc>(() => _i18.SignUpFormBloc(
          gh<_i19.SignInWithGoogleUseCase>(),
          gh<_i19.RegisterWithEmailAndPasswordUseCase>(),
          gh<_i19.SignInWithEmailAndPasswordUseCase>(),
        ));
    gh.factory<_i20.SubmitUserDataUsecase>(
        () => _i20.SubmitUserDataUsecase(gh<_i9.IDatafacade>()));
    gh.factory<_i21.DataCollectionBloc>(() => _i21.DataCollectionBloc(
          gh<_i20.SubmitUserDataUsecase>(),
          gh<_i14.SelectInterestsUseCase>(),
        ));
    gh.factory<_i22.GetSignedInUserUseCase>(
        () => _i22.GetSignedInUserUseCase(gh<_i7.IAuthFacade>()));
    gh.factory<_i23.GetUserDataUseCase>(
        () => _i23.GetUserDataUseCase(gh<_i9.IDatafacade>()));
    gh.factory<_i24.OnboardBloc>(
        () => _i24.OnboardBloc(gh<_i23.GetUserDataUseCase>()));
    gh.factory<_i25.SignInFormBloc>(() => _i25.SignInFormBloc(
          gh<_i19.RegisterWithEmailAndPasswordUseCase>(),
          gh<_i19.SignInWithEmailAndPasswordUseCase>(),
          gh<_i19.SignInWithGoogleUseCase>(),
        ));
    gh.factory<_i26.AuthBloc>(() => _i26.AuthBloc(
          gh<_i19.GetSignedInUserUseCase>(),
          gh<_i19.SignOutUseCase>(),
          gh<_i23.GetUserDataUseCase>(),
        ));
    return this;
  }
}

class _$FirebaseInjectableModule extends _i27.FirebaseInjectableModule {}
