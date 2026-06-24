// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserListModel {

 String get id; String get userId; String get title; String? get description; MediaListType get listType; bool get isPinned; List<String> get tags; DateTime? get createdAt; DateTime? get updatedAt; int get itemCount; int get likesCount;
/// Create a copy of UserListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserListModelCopyWith<UserListModel> get copyWith => _$UserListModelCopyWithImpl<UserListModel>(this as UserListModel, _$identity);

  /// Serializes this UserListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.listType, listType) || other.listType == listType)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,description,listType,isPinned,const DeepCollectionEquality().hash(tags),createdAt,updatedAt,itemCount,likesCount);

@override
String toString() {
  return 'UserListModel(id: $id, userId: $userId, title: $title, description: $description, listType: $listType, isPinned: $isPinned, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, itemCount: $itemCount, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class $UserListModelCopyWith<$Res>  {
  factory $UserListModelCopyWith(UserListModel value, $Res Function(UserListModel) _then) = _$UserListModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String? description, MediaListType listType, bool isPinned, List<String> tags, DateTime? createdAt, DateTime? updatedAt, int itemCount, int likesCount
});




}
/// @nodoc
class _$UserListModelCopyWithImpl<$Res>
    implements $UserListModelCopyWith<$Res> {
  _$UserListModelCopyWithImpl(this._self, this._then);

  final UserListModel _self;
  final $Res Function(UserListModel) _then;

/// Create a copy of UserListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? description = freezed,Object? listType = null,Object? isPinned = null,Object? tags = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? itemCount = null,Object? likesCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,listType: null == listType ? _self.listType : listType // ignore: cast_nullable_to_non_nullable
as MediaListType,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserListModel].
extension UserListModelPatterns on UserListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserListModel value)  $default,){
final _that = this;
switch (_that) {
case _UserListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserListModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? description,  MediaListType listType,  bool isPinned,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt,  int itemCount,  int likesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserListModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.description,_that.listType,_that.isPinned,_that.tags,_that.createdAt,_that.updatedAt,_that.itemCount,_that.likesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? description,  MediaListType listType,  bool isPinned,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt,  int itemCount,  int likesCount)  $default,) {final _that = this;
switch (_that) {
case _UserListModel():
return $default(_that.id,_that.userId,_that.title,_that.description,_that.listType,_that.isPinned,_that.tags,_that.createdAt,_that.updatedAt,_that.itemCount,_that.likesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String? description,  MediaListType listType,  bool isPinned,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt,  int itemCount,  int likesCount)?  $default,) {final _that = this;
switch (_that) {
case _UserListModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.description,_that.listType,_that.isPinned,_that.tags,_that.createdAt,_that.updatedAt,_that.itemCount,_that.likesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserListModel implements UserListModel {
  const _UserListModel({required this.id, required this.userId, required this.title, this.description, this.listType = MediaListType.public, this.isPinned = false, final  List<String> tags = const [], this.createdAt, this.updatedAt, this.itemCount = 0, this.likesCount = 0}): _tags = tags;
  factory _UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  MediaListType listType;
@override@JsonKey() final  bool isPinned;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int itemCount;
@override@JsonKey() final  int likesCount;

/// Create a copy of UserListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserListModelCopyWith<_UserListModel> get copyWith => __$UserListModelCopyWithImpl<_UserListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.listType, listType) || other.listType == listType)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,description,listType,isPinned,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt,itemCount,likesCount);

@override
String toString() {
  return 'UserListModel(id: $id, userId: $userId, title: $title, description: $description, listType: $listType, isPinned: $isPinned, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, itemCount: $itemCount, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class _$UserListModelCopyWith<$Res> implements $UserListModelCopyWith<$Res> {
  factory _$UserListModelCopyWith(_UserListModel value, $Res Function(_UserListModel) _then) = __$UserListModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String? description, MediaListType listType, bool isPinned, List<String> tags, DateTime? createdAt, DateTime? updatedAt, int itemCount, int likesCount
});




}
/// @nodoc
class __$UserListModelCopyWithImpl<$Res>
    implements _$UserListModelCopyWith<$Res> {
  __$UserListModelCopyWithImpl(this._self, this._then);

  final _UserListModel _self;
  final $Res Function(_UserListModel) _then;

/// Create a copy of UserListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? description = freezed,Object? listType = null,Object? isPinned = null,Object? tags = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? itemCount = null,Object? likesCount = null,}) {
  return _then(_UserListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,listType: null == listType ? _self.listType : listType // ignore: cast_nullable_to_non_nullable
as MediaListType,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
