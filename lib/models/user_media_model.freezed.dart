// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMediaModel {

 String get id;@JsonKey(name: 'media_id') int get mediaId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'media_type') MediaType get mediaType; WatchStatus get status;@JsonKey(name: 'season_progress') int get seasonProgress;@JsonKey(name: 'episode_progress') int get episodeProgress;@JsonKey(name: 'total_episodes') int get totalEpisodes;@JsonKey(name: 'rewatch_count') int get rewatchCount;@JsonKey(name: 'user_rating') double? get userRating;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of UserMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMediaModelCopyWith<UserMediaModel> get copyWith => _$UserMediaModelCopyWithImpl<UserMediaModel>(this as UserMediaModel, _$identity);

  /// Serializes this UserMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status)&&(identical(other.seasonProgress, seasonProgress) || other.seasonProgress == seasonProgress)&&(identical(other.episodeProgress, episodeProgress) || other.episodeProgress == episodeProgress)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.rewatchCount, rewatchCount) || other.rewatchCount == rewatchCount)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,userId,mediaType,status,seasonProgress,episodeProgress,totalEpisodes,rewatchCount,userRating,startedAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserMediaModel(id: $id, mediaId: $mediaId, userId: $userId, mediaType: $mediaType, status: $status, seasonProgress: $seasonProgress, episodeProgress: $episodeProgress, totalEpisodes: $totalEpisodes, rewatchCount: $rewatchCount, userRating: $userRating, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserMediaModelCopyWith<$Res>  {
  factory $UserMediaModelCopyWith(UserMediaModel value, $Res Function(UserMediaModel) _then) = _$UserMediaModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_type') MediaType mediaType, WatchStatus status,@JsonKey(name: 'season_progress') int seasonProgress,@JsonKey(name: 'episode_progress') int episodeProgress,@JsonKey(name: 'total_episodes') int totalEpisodes,@JsonKey(name: 'rewatch_count') int rewatchCount,@JsonKey(name: 'user_rating') double? userRating,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$UserMediaModelCopyWithImpl<$Res>
    implements $UserMediaModelCopyWith<$Res> {
  _$UserMediaModelCopyWithImpl(this._self, this._then);

  final UserMediaModel _self;
  final $Res Function(UserMediaModel) _then;

/// Create a copy of UserMediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaId = null,Object? userId = null,Object? mediaType = null,Object? status = null,Object? seasonProgress = null,Object? episodeProgress = null,Object? totalEpisodes = null,Object? rewatchCount = null,Object? userRating = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WatchStatus,seasonProgress: null == seasonProgress ? _self.seasonProgress : seasonProgress // ignore: cast_nullable_to_non_nullable
as int,episodeProgress: null == episodeProgress ? _self.episodeProgress : episodeProgress // ignore: cast_nullable_to_non_nullable
as int,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,rewatchCount: null == rewatchCount ? _self.rewatchCount : rewatchCount // ignore: cast_nullable_to_non_nullable
as int,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMediaModel].
extension UserMediaModelPatterns on UserMediaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMediaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _UserMediaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserMediaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'season_progress')  int seasonProgress, @JsonKey(name: 'episode_progress')  int episodeProgress, @JsonKey(name: 'total_episodes')  int totalEpisodes, @JsonKey(name: 'rewatch_count')  int rewatchCount, @JsonKey(name: 'user_rating')  double? userRating, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMediaModel() when $default != null:
return $default(_that.id,_that.mediaId,_that.userId,_that.mediaType,_that.status,_that.seasonProgress,_that.episodeProgress,_that.totalEpisodes,_that.rewatchCount,_that.userRating,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'season_progress')  int seasonProgress, @JsonKey(name: 'episode_progress')  int episodeProgress, @JsonKey(name: 'total_episodes')  int totalEpisodes, @JsonKey(name: 'rewatch_count')  int rewatchCount, @JsonKey(name: 'user_rating')  double? userRating, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserMediaModel():
return $default(_that.id,_that.mediaId,_that.userId,_that.mediaType,_that.status,_that.seasonProgress,_that.episodeProgress,_that.totalEpisodes,_that.rewatchCount,_that.userRating,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_type')  MediaType mediaType,  WatchStatus status, @JsonKey(name: 'season_progress')  int seasonProgress, @JsonKey(name: 'episode_progress')  int episodeProgress, @JsonKey(name: 'total_episodes')  int totalEpisodes, @JsonKey(name: 'rewatch_count')  int rewatchCount, @JsonKey(name: 'user_rating')  double? userRating, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserMediaModel() when $default != null:
return $default(_that.id,_that.mediaId,_that.userId,_that.mediaType,_that.status,_that.seasonProgress,_that.episodeProgress,_that.totalEpisodes,_that.rewatchCount,_that.userRating,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserMediaModel implements UserMediaModel {
  const _UserMediaModel({required this.id, @JsonKey(name: 'media_id') required this.mediaId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'media_type') required this.mediaType, required this.status, @JsonKey(name: 'season_progress') this.seasonProgress = 0, @JsonKey(name: 'episode_progress') this.episodeProgress = 0, @JsonKey(name: 'total_episodes') this.totalEpisodes = 0, @JsonKey(name: 'rewatch_count') this.rewatchCount = 0, @JsonKey(name: 'user_rating') this.userRating, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _UserMediaModel.fromJson(Map<String, dynamic> json) => _$UserMediaModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'media_id') final  int mediaId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'media_type') final  MediaType mediaType;
@override final  WatchStatus status;
@override@JsonKey(name: 'season_progress') final  int seasonProgress;
@override@JsonKey(name: 'episode_progress') final  int episodeProgress;
@override@JsonKey(name: 'total_episodes') final  int totalEpisodes;
@override@JsonKey(name: 'rewatch_count') final  int rewatchCount;
@override@JsonKey(name: 'user_rating') final  double? userRating;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of UserMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMediaModelCopyWith<_UserMediaModel> get copyWith => __$UserMediaModelCopyWithImpl<_UserMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.status, status) || other.status == status)&&(identical(other.seasonProgress, seasonProgress) || other.seasonProgress == seasonProgress)&&(identical(other.episodeProgress, episodeProgress) || other.episodeProgress == episodeProgress)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.rewatchCount, rewatchCount) || other.rewatchCount == rewatchCount)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaId,userId,mediaType,status,seasonProgress,episodeProgress,totalEpisodes,rewatchCount,userRating,startedAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserMediaModel(id: $id, mediaId: $mediaId, userId: $userId, mediaType: $mediaType, status: $status, seasonProgress: $seasonProgress, episodeProgress: $episodeProgress, totalEpisodes: $totalEpisodes, rewatchCount: $rewatchCount, userRating: $userRating, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserMediaModelCopyWith<$Res> implements $UserMediaModelCopyWith<$Res> {
  factory _$UserMediaModelCopyWith(_UserMediaModel value, $Res Function(_UserMediaModel) _then) = __$UserMediaModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_type') MediaType mediaType, WatchStatus status,@JsonKey(name: 'season_progress') int seasonProgress,@JsonKey(name: 'episode_progress') int episodeProgress,@JsonKey(name: 'total_episodes') int totalEpisodes,@JsonKey(name: 'rewatch_count') int rewatchCount,@JsonKey(name: 'user_rating') double? userRating,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$UserMediaModelCopyWithImpl<$Res>
    implements _$UserMediaModelCopyWith<$Res> {
  __$UserMediaModelCopyWithImpl(this._self, this._then);

  final _UserMediaModel _self;
  final $Res Function(_UserMediaModel) _then;

/// Create a copy of UserMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaId = null,Object? userId = null,Object? mediaType = null,Object? status = null,Object? seasonProgress = null,Object? episodeProgress = null,Object? totalEpisodes = null,Object? rewatchCount = null,Object? userRating = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WatchStatus,seasonProgress: null == seasonProgress ? _self.seasonProgress : seasonProgress // ignore: cast_nullable_to_non_nullable
as int,episodeProgress: null == episodeProgress ? _self.episodeProgress : episodeProgress // ignore: cast_nullable_to_non_nullable
as int,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,rewatchCount: null == rewatchCount ? _self.rewatchCount : rewatchCount // ignore: cast_nullable_to_non_nullable
as int,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
