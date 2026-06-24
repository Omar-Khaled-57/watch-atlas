// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaModel {

 int get id; MediaType get mediaType; String get title; String? get originalTitle; String? get nativeTitle; String? get romanizedTitle; String? get overview; String? get posterPath; String? get backdropPath; String? get trailerUrl; double? get voteAverage; int? get voteCount; double get popularity; DateTime? get releaseDate; int? get runtime; List<String>? get genres; List<String>? get countries; String? get status; String? get language; bool? get adult; bool get isCustom; int get totalEpisodes; int get totalSeasons; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of MediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaModelCopyWith<MediaModel> get copyWith => _$MediaModelCopyWithImpl<MediaModel>(this as MediaModel, _$identity);

  /// Serializes this MediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.nativeTitle, nativeTitle) || other.nativeTitle == nativeTitle)&&(identical(other.romanizedTitle, romanizedTitle) || other.romanizedTitle == romanizedTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.trailerUrl, trailerUrl) || other.trailerUrl == trailerUrl)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.countries, countries)&&(identical(other.status, status) || other.status == status)&&(identical(other.language, language) || other.language == language)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.totalSeasons, totalSeasons) || other.totalSeasons == totalSeasons)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mediaType,title,originalTitle,nativeTitle,romanizedTitle,overview,posterPath,backdropPath,trailerUrl,voteAverage,voteCount,popularity,releaseDate,runtime,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(countries),status,language,adult,isCustom,totalEpisodes,totalSeasons,createdAt,updatedAt]);

@override
String toString() {
  return 'MediaModel(id: $id, mediaType: $mediaType, title: $title, originalTitle: $originalTitle, nativeTitle: $nativeTitle, romanizedTitle: $romanizedTitle, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, trailerUrl: $trailerUrl, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, countries: $countries, status: $status, language: $language, adult: $adult, isCustom: $isCustom, totalEpisodes: $totalEpisodes, totalSeasons: $totalSeasons, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MediaModelCopyWith<$Res>  {
  factory $MediaModelCopyWith(MediaModel value, $Res Function(MediaModel) _then) = _$MediaModelCopyWithImpl;
@useResult
$Res call({
 int id, MediaType mediaType, String title, String? originalTitle, String? nativeTitle, String? romanizedTitle, String? overview, String? posterPath, String? backdropPath, String? trailerUrl, double? voteAverage, int? voteCount, double popularity, DateTime? releaseDate, int? runtime, List<String>? genres, List<String>? countries, String? status, String? language, bool? adult, bool isCustom, int totalEpisodes, int totalSeasons, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$MediaModelCopyWithImpl<$Res>
    implements $MediaModelCopyWith<$Res> {
  _$MediaModelCopyWithImpl(this._self, this._then);

  final MediaModel _self;
  final $Res Function(MediaModel) _then;

/// Create a copy of MediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaType = null,Object? title = null,Object? originalTitle = freezed,Object? nativeTitle = freezed,Object? romanizedTitle = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? trailerUrl = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = null,Object? releaseDate = freezed,Object? runtime = freezed,Object? genres = freezed,Object? countries = freezed,Object? status = freezed,Object? language = freezed,Object? adult = freezed,Object? isCustom = null,Object? totalEpisodes = null,Object? totalSeasons = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,nativeTitle: freezed == nativeTitle ? _self.nativeTitle : nativeTitle // ignore: cast_nullable_to_non_nullable
as String?,romanizedTitle: freezed == romanizedTitle ? _self.romanizedTitle : romanizedTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,trailerUrl: freezed == trailerUrl ? _self.trailerUrl : trailerUrl // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,countries: freezed == countries ? _self.countries : countries // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,totalSeasons: null == totalSeasons ? _self.totalSeasons : totalSeasons // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaModel].
extension MediaModelPatterns on MediaModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  MediaType mediaType,  String title,  String? originalTitle,  String? nativeTitle,  String? romanizedTitle,  String? overview,  String? posterPath,  String? backdropPath,  String? trailerUrl,  double? voteAverage,  int? voteCount,  double popularity,  DateTime? releaseDate,  int? runtime,  List<String>? genres,  List<String>? countries,  String? status,  String? language,  bool? adult,  bool isCustom,  int totalEpisodes,  int totalSeasons,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaModel() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.nativeTitle,_that.romanizedTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.trailerUrl,_that.voteAverage,_that.voteCount,_that.popularity,_that.releaseDate,_that.runtime,_that.genres,_that.countries,_that.status,_that.language,_that.adult,_that.isCustom,_that.totalEpisodes,_that.totalSeasons,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  MediaType mediaType,  String title,  String? originalTitle,  String? nativeTitle,  String? romanizedTitle,  String? overview,  String? posterPath,  String? backdropPath,  String? trailerUrl,  double? voteAverage,  int? voteCount,  double popularity,  DateTime? releaseDate,  int? runtime,  List<String>? genres,  List<String>? countries,  String? status,  String? language,  bool? adult,  bool isCustom,  int totalEpisodes,  int totalSeasons,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MediaModel():
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.nativeTitle,_that.romanizedTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.trailerUrl,_that.voteAverage,_that.voteCount,_that.popularity,_that.releaseDate,_that.runtime,_that.genres,_that.countries,_that.status,_that.language,_that.adult,_that.isCustom,_that.totalEpisodes,_that.totalSeasons,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  MediaType mediaType,  String title,  String? originalTitle,  String? nativeTitle,  String? romanizedTitle,  String? overview,  String? posterPath,  String? backdropPath,  String? trailerUrl,  double? voteAverage,  int? voteCount,  double popularity,  DateTime? releaseDate,  int? runtime,  List<String>? genres,  List<String>? countries,  String? status,  String? language,  bool? adult,  bool isCustom,  int totalEpisodes,  int totalSeasons,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MediaModel() when $default != null:
return $default(_that.id,_that.mediaType,_that.title,_that.originalTitle,_that.nativeTitle,_that.romanizedTitle,_that.overview,_that.posterPath,_that.backdropPath,_that.trailerUrl,_that.voteAverage,_that.voteCount,_that.popularity,_that.releaseDate,_that.runtime,_that.genres,_that.countries,_that.status,_that.language,_that.adult,_that.isCustom,_that.totalEpisodes,_that.totalSeasons,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaModel implements MediaModel {
  const _MediaModel({required this.id, required this.mediaType, required this.title, this.originalTitle, this.nativeTitle, this.romanizedTitle, this.overview, this.posterPath, this.backdropPath, this.trailerUrl, this.voteAverage, this.voteCount, this.popularity = 0, this.releaseDate, this.runtime, final  List<String>? genres, final  List<String>? countries, this.status, this.language, this.adult, this.isCustom = false, this.totalEpisodes = 0, this.totalSeasons = 0, this.createdAt, this.updatedAt}): _genres = genres,_countries = countries;
  factory _MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

@override final  int id;
@override final  MediaType mediaType;
@override final  String title;
@override final  String? originalTitle;
@override final  String? nativeTitle;
@override final  String? romanizedTitle;
@override final  String? overview;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  String? trailerUrl;
@override final  double? voteAverage;
@override final  int? voteCount;
@override@JsonKey() final  double popularity;
@override final  DateTime? releaseDate;
@override final  int? runtime;
 final  List<String>? _genres;
@override List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _countries;
@override List<String>? get countries {
  final value = _countries;
  if (value == null) return null;
  if (_countries is EqualUnmodifiableListView) return _countries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? status;
@override final  String? language;
@override final  bool? adult;
@override@JsonKey() final  bool isCustom;
@override@JsonKey() final  int totalEpisodes;
@override@JsonKey() final  int totalSeasons;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of MediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaModelCopyWith<_MediaModel> get copyWith => __$MediaModelCopyWithImpl<_MediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.nativeTitle, nativeTitle) || other.nativeTitle == nativeTitle)&&(identical(other.romanizedTitle, romanizedTitle) || other.romanizedTitle == romanizedTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.trailerUrl, trailerUrl) || other.trailerUrl == trailerUrl)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._countries, _countries)&&(identical(other.status, status) || other.status == status)&&(identical(other.language, language) || other.language == language)&&(identical(other.adult, adult) || other.adult == adult)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.totalSeasons, totalSeasons) || other.totalSeasons == totalSeasons)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mediaType,title,originalTitle,nativeTitle,romanizedTitle,overview,posterPath,backdropPath,trailerUrl,voteAverage,voteCount,popularity,releaseDate,runtime,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_countries),status,language,adult,isCustom,totalEpisodes,totalSeasons,createdAt,updatedAt]);

@override
String toString() {
  return 'MediaModel(id: $id, mediaType: $mediaType, title: $title, originalTitle: $originalTitle, nativeTitle: $nativeTitle, romanizedTitle: $romanizedTitle, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, trailerUrl: $trailerUrl, voteAverage: $voteAverage, voteCount: $voteCount, popularity: $popularity, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, countries: $countries, status: $status, language: $language, adult: $adult, isCustom: $isCustom, totalEpisodes: $totalEpisodes, totalSeasons: $totalSeasons, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaModelCopyWith<$Res> implements $MediaModelCopyWith<$Res> {
  factory _$MediaModelCopyWith(_MediaModel value, $Res Function(_MediaModel) _then) = __$MediaModelCopyWithImpl;
@override @useResult
$Res call({
 int id, MediaType mediaType, String title, String? originalTitle, String? nativeTitle, String? romanizedTitle, String? overview, String? posterPath, String? backdropPath, String? trailerUrl, double? voteAverage, int? voteCount, double popularity, DateTime? releaseDate, int? runtime, List<String>? genres, List<String>? countries, String? status, String? language, bool? adult, bool isCustom, int totalEpisodes, int totalSeasons, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$MediaModelCopyWithImpl<$Res>
    implements _$MediaModelCopyWith<$Res> {
  __$MediaModelCopyWithImpl(this._self, this._then);

  final _MediaModel _self;
  final $Res Function(_MediaModel) _then;

/// Create a copy of MediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaType = null,Object? title = null,Object? originalTitle = freezed,Object? nativeTitle = freezed,Object? romanizedTitle = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? trailerUrl = freezed,Object? voteAverage = freezed,Object? voteCount = freezed,Object? popularity = null,Object? releaseDate = freezed,Object? runtime = freezed,Object? genres = freezed,Object? countries = freezed,Object? status = freezed,Object? language = freezed,Object? adult = freezed,Object? isCustom = null,Object? totalEpisodes = null,Object? totalSeasons = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,nativeTitle: freezed == nativeTitle ? _self.nativeTitle : nativeTitle // ignore: cast_nullable_to_non_nullable
as String?,romanizedTitle: freezed == romanizedTitle ? _self.romanizedTitle : romanizedTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,trailerUrl: freezed == trailerUrl ? _self.trailerUrl : trailerUrl // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,voteCount: freezed == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int?,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as double,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,countries: freezed == countries ? _self._countries : countries // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,adult: freezed == adult ? _self.adult : adult // ignore: cast_nullable_to_non_nullable
as bool?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,totalSeasons: null == totalSeasons ? _self.totalSeasons : totalSeasons // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
