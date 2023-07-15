// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PodcastModel _$PodcastModelFromJson(Map<String, dynamic> json) {
  return _PodcastModel.fromJson(json);
}

/// @nodoc
mixin _$PodcastModel {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String? get copyright => throw _privateConstructorUsedError;
  List<EpisodeModel>? get episodes => throw _privateConstructorUsedError;
  bool? get paid => throw _privateConstructorUsedError;
  AuthorModel? get author => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PodcastModelCopyWith<PodcastModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PodcastModelCopyWith<$Res> {
  factory $PodcastModelCopyWith(
          PodcastModel value, $Res Function(PodcastModel) then) =
      _$PodcastModelCopyWithImpl<$Res, PodcastModel>;
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? description,
      String? imageUrl,
      String? link,
      String? copyright,
      List<EpisodeModel>? episodes,
      bool? paid,
      AuthorModel? author});

  $AuthorModelCopyWith<$Res>? get author;
}

/// @nodoc
class _$PodcastModelCopyWithImpl<$Res, $Val extends PodcastModel>
    implements $PodcastModelCopyWith<$Res> {
  _$PodcastModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? link = freezed,
    Object? copyright = freezed,
    Object? episodes = freezed,
    Object? paid = freezed,
    Object? author = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      episodes: freezed == episodes
          ? _value.episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeModel>?,
      paid: freezed == paid
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as bool?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as AuthorModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthorModelCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $AuthorModelCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PodcastModelCopyWith<$Res>
    implements $PodcastModelCopyWith<$Res> {
  factory _$$_PodcastModelCopyWith(
          _$_PodcastModel value, $Res Function(_$_PodcastModel) then) =
      __$$_PodcastModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? description,
      String? imageUrl,
      String? link,
      String? copyright,
      List<EpisodeModel>? episodes,
      bool? paid,
      AuthorModel? author});

  @override
  $AuthorModelCopyWith<$Res>? get author;
}

/// @nodoc
class __$$_PodcastModelCopyWithImpl<$Res>
    extends _$PodcastModelCopyWithImpl<$Res, _$_PodcastModel>
    implements _$$_PodcastModelCopyWith<$Res> {
  __$$_PodcastModelCopyWithImpl(
      _$_PodcastModel _value, $Res Function(_$_PodcastModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? link = freezed,
    Object? copyright = freezed,
    Object? episodes = freezed,
    Object? paid = freezed,
    Object? author = freezed,
  }) {
    return _then(_$_PodcastModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      copyright: freezed == copyright
          ? _value.copyright
          : copyright // ignore: cast_nullable_to_non_nullable
              as String?,
      episodes: freezed == episodes
          ? _value._episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeModel>?,
      paid: freezed == paid
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as bool?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as AuthorModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PodcastModel implements _PodcastModel {
  const _$_PodcastModel(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.link,
      this.copyright,
      final List<EpisodeModel>? episodes,
      this.paid,
      this.author})
      : _episodes = episodes;

  factory _$_PodcastModel.fromJson(Map<String, dynamic> json) =>
      _$$_PodcastModelFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? link;
  @override
  final String? copyright;
  final List<EpisodeModel>? _episodes;
  @override
  List<EpisodeModel>? get episodes {
    final value = _episodes;
    if (value == null) return null;
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? paid;
  @override
  final AuthorModel? author;

  @override
  String toString() {
    return 'PodcastModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, link: $link, copyright: $copyright, episodes: $episodes, paid: $paid, author: $author)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PodcastModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.copyright, copyright) ||
                other.copyright == copyright) &&
            const DeepCollectionEquality().equals(other._episodes, _episodes) &&
            (identical(other.paid, paid) || other.paid == paid) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      imageUrl,
      link,
      copyright,
      const DeepCollectionEquality().hash(_episodes),
      paid,
      author);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PodcastModelCopyWith<_$_PodcastModel> get copyWith =>
      __$$_PodcastModelCopyWithImpl<_$_PodcastModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PodcastModelToJson(
      this,
    );
  }
}

abstract class _PodcastModel implements PodcastModel {
  const factory _PodcastModel(
      {final String? id,
      final String? title,
      final String? description,
      final String? imageUrl,
      final String? link,
      final String? copyright,
      final List<EpisodeModel>? episodes,
      final bool? paid,
      final AuthorModel? author}) = _$_PodcastModel;

  factory _PodcastModel.fromJson(Map<String, dynamic> json) =
      _$_PodcastModel.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get link;
  @override
  String? get copyright;
  @override
  List<EpisodeModel>? get episodes;
  @override
  bool? get paid;
  @override
  AuthorModel? get author;
  @override
  @JsonKey(ignore: true)
  _$$_PodcastModelCopyWith<_$_PodcastModel> get copyWith =>
      throw _privateConstructorUsedError;
}

EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) {
  return _EpisodeModel.fromJson(json);
}

/// @nodoc
mixin _$EpisodeModel {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  Duration? get duration => throw _privateConstructorUsedError;
  bool? get isPaused => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EpisodeModelCopyWith<EpisodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EpisodeModelCopyWith<$Res> {
  factory $EpisodeModelCopyWith(
          EpisodeModel value, $Res Function(EpisodeModel) then) =
      _$EpisodeModelCopyWithImpl<$Res, EpisodeModel>;
  @useResult
  $Res call(
      {String id,
      String? title,
      String? description,
      String? audioUrl,
      DateTime? releaseDate,
      Duration? duration,
      bool? isPaused,
      String? link});
}

/// @nodoc
class _$EpisodeModelCopyWithImpl<$Res, $Val extends EpisodeModel>
    implements $EpisodeModelCopyWith<$Res> {
  _$EpisodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? audioUrl = freezed,
    Object? releaseDate = freezed,
    Object? duration = freezed,
    Object? isPaused = freezed,
    Object? link = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isPaused: freezed == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EpisodeModelCopyWith<$Res>
    implements $EpisodeModelCopyWith<$Res> {
  factory _$$_EpisodeModelCopyWith(
          _$_EpisodeModel value, $Res Function(_$_EpisodeModel) then) =
      __$$_EpisodeModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? title,
      String? description,
      String? audioUrl,
      DateTime? releaseDate,
      Duration? duration,
      bool? isPaused,
      String? link});
}

/// @nodoc
class __$$_EpisodeModelCopyWithImpl<$Res>
    extends _$EpisodeModelCopyWithImpl<$Res, _$_EpisodeModel>
    implements _$$_EpisodeModelCopyWith<$Res> {
  __$$_EpisodeModelCopyWithImpl(
      _$_EpisodeModel _value, $Res Function(_$_EpisodeModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? audioUrl = freezed,
    Object? releaseDate = freezed,
    Object? duration = freezed,
    Object? isPaused = freezed,
    Object? link = freezed,
  }) {
    return _then(_$_EpisodeModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isPaused: freezed == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EpisodeModel implements _EpisodeModel {
  _$_EpisodeModel(
      {required this.id,
      this.title,
      this.description,
      this.audioUrl,
      this.releaseDate,
      this.duration,
      this.isPaused,
      this.link});

  factory _$_EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$$_EpisodeModelFromJson(json);

  @override
  final String id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? audioUrl;
  @override
  final DateTime? releaseDate;
  @override
  final Duration? duration;
  @override
  final bool? isPaused;
  @override
  final String? link;

  @override
  String toString() {
    return 'EpisodeModel(id: $id, title: $title, description: $description, audioUrl: $audioUrl, releaseDate: $releaseDate, duration: $duration, isPaused: $isPaused, link: $link)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EpisodeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, audioUrl,
      releaseDate, duration, isPaused, link);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EpisodeModelCopyWith<_$_EpisodeModel> get copyWith =>
      __$$_EpisodeModelCopyWithImpl<_$_EpisodeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EpisodeModelToJson(
      this,
    );
  }
}

abstract class _EpisodeModel implements EpisodeModel {
  factory _EpisodeModel(
      {required final String id,
      final String? title,
      final String? description,
      final String? audioUrl,
      final DateTime? releaseDate,
      final Duration? duration,
      final bool? isPaused,
      final String? link}) = _$_EpisodeModel;

  factory _EpisodeModel.fromJson(Map<String, dynamic> json) =
      _$_EpisodeModel.fromJson;

  @override
  String get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get audioUrl;
  @override
  DateTime? get releaseDate;
  @override
  Duration? get duration;
  @override
  bool? get isPaused;
  @override
  String? get link;
  @override
  @JsonKey(ignore: true)
  _$$_EpisodeModelCopyWith<_$_EpisodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) {
  return _AuthorModel.fromJson(json);
}

/// @nodoc
mixin _$AuthorModel {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthorModelCopyWith<AuthorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorModelCopyWith<$Res> {
  factory $AuthorModelCopyWith(
          AuthorModel value, $Res Function(AuthorModel) then) =
      _$AuthorModelCopyWithImpl<$Res, AuthorModel>;
  @useResult
  $Res call({String id, String? name, String? bio, String? imageUrl});
}

/// @nodoc
class _$AuthorModelCopyWithImpl<$Res, $Val extends AuthorModel>
    implements $AuthorModelCopyWith<$Res> {
  _$AuthorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? bio = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AuthorModelCopyWith<$Res>
    implements $AuthorModelCopyWith<$Res> {
  factory _$$_AuthorModelCopyWith(
          _$_AuthorModel value, $Res Function(_$_AuthorModel) then) =
      __$$_AuthorModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, String? bio, String? imageUrl});
}

/// @nodoc
class __$$_AuthorModelCopyWithImpl<$Res>
    extends _$AuthorModelCopyWithImpl<$Res, _$_AuthorModel>
    implements _$$_AuthorModelCopyWith<$Res> {
  __$$_AuthorModelCopyWithImpl(
      _$_AuthorModel _value, $Res Function(_$_AuthorModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? bio = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_AuthorModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthorModel implements _AuthorModel {
  _$_AuthorModel({required this.id, this.name, this.bio, this.imageUrl});

  factory _$_AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$$_AuthorModelFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? bio;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AuthorModel(id: $id, name: $name, bio: $bio, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthorModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, bio, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthorModelCopyWith<_$_AuthorModel> get copyWith =>
      __$$_AuthorModelCopyWithImpl<_$_AuthorModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthorModelToJson(
      this,
    );
  }
}

abstract class _AuthorModel implements AuthorModel {
  factory _AuthorModel(
      {required final String id,
      final String? name,
      final String? bio,
      final String? imageUrl}) = _$_AuthorModel;

  factory _AuthorModel.fromJson(Map<String, dynamic> json) =
      _$_AuthorModel.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get bio;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_AuthorModelCopyWith<_$_AuthorModel> get copyWith =>
      throw _privateConstructorUsedError;
}
