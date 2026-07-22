// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_queue_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncQueueModel {

 String get id; String get tableName; String get recordId; SyncOperation get operation; Map<String, dynamic> get data; int get retryCount; String? get errorMessage; DateTime? get createdAt;
/// Create a copy of SyncQueueModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncQueueModelCopyWith<SyncQueueModel> get copyWith => _$SyncQueueModelCopyWithImpl<SyncQueueModel>(this as SyncQueueModel, _$identity);

  /// Serializes this SyncQueueModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncQueueModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,recordId,operation,const DeepCollectionEquality().hash(data),retryCount,errorMessage,createdAt);

@override
String toString() {
  return 'SyncQueueModel(id: $id, tableName: $tableName, recordId: $recordId, operation: $operation, data: $data, retryCount: $retryCount, errorMessage: $errorMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SyncQueueModelCopyWith<$Res>  {
  factory $SyncQueueModelCopyWith(SyncQueueModel value, $Res Function(SyncQueueModel) _then) = _$SyncQueueModelCopyWithImpl;
@useResult
$Res call({
 String id, String tableName, String recordId, SyncOperation operation, Map<String, dynamic> data, int retryCount, String? errorMessage, DateTime? createdAt
});




}
/// @nodoc
class _$SyncQueueModelCopyWithImpl<$Res>
    implements $SyncQueueModelCopyWith<$Res> {
  _$SyncQueueModelCopyWithImpl(this._self, this._then);

  final SyncQueueModel _self;
  final $Res Function(SyncQueueModel) _then;

/// Create a copy of SyncQueueModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tableName = null,Object? recordId = null,Object? operation = null,Object? data = null,Object? retryCount = null,Object? errorMessage = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncQueueModel].
extension SyncQueueModelPatterns on SyncQueueModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncQueueModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncQueueModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncQueueModel value)  $default,){
final _that = this;
switch (_that) {
case _SyncQueueModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncQueueModel value)?  $default,){
final _that = this;
switch (_that) {
case _SyncQueueModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tableName,  String recordId,  SyncOperation operation,  Map<String, dynamic> data,  int retryCount,  String? errorMessage,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncQueueModel() when $default != null:
return $default(_that.id,_that.tableName,_that.recordId,_that.operation,_that.data,_that.retryCount,_that.errorMessage,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tableName,  String recordId,  SyncOperation operation,  Map<String, dynamic> data,  int retryCount,  String? errorMessage,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SyncQueueModel():
return $default(_that.id,_that.tableName,_that.recordId,_that.operation,_that.data,_that.retryCount,_that.errorMessage,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tableName,  String recordId,  SyncOperation operation,  Map<String, dynamic> data,  int retryCount,  String? errorMessage,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncQueueModel() when $default != null:
return $default(_that.id,_that.tableName,_that.recordId,_that.operation,_that.data,_that.retryCount,_that.errorMessage,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncQueueModel implements SyncQueueModel {
  const _SyncQueueModel({required this.id, required this.tableName, required this.recordId, required this.operation, required final  Map<String, dynamic> data, this.retryCount = 0, this.errorMessage, this.createdAt}): _data = data;
  factory _SyncQueueModel.fromJson(Map<String, dynamic> json) => _$SyncQueueModelFromJson(json);

@override final  String id;
@override final  String tableName;
@override final  String recordId;
@override final  SyncOperation operation;
 final  Map<String, dynamic> _data;
@override Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override@JsonKey() final  int retryCount;
@override final  String? errorMessage;
@override final  DateTime? createdAt;

/// Create a copy of SyncQueueModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncQueueModelCopyWith<_SyncQueueModel> get copyWith => __$SyncQueueModelCopyWithImpl<_SyncQueueModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncQueueModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncQueueModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,recordId,operation,const DeepCollectionEquality().hash(_data),retryCount,errorMessage,createdAt);

@override
String toString() {
  return 'SyncQueueModel(id: $id, tableName: $tableName, recordId: $recordId, operation: $operation, data: $data, retryCount: $retryCount, errorMessage: $errorMessage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SyncQueueModelCopyWith<$Res> implements $SyncQueueModelCopyWith<$Res> {
  factory _$SyncQueueModelCopyWith(_SyncQueueModel value, $Res Function(_SyncQueueModel) _then) = __$SyncQueueModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String tableName, String recordId, SyncOperation operation, Map<String, dynamic> data, int retryCount, String? errorMessage, DateTime? createdAt
});




}
/// @nodoc
class __$SyncQueueModelCopyWithImpl<$Res>
    implements _$SyncQueueModelCopyWith<$Res> {
  __$SyncQueueModelCopyWithImpl(this._self, this._then);

  final _SyncQueueModel _self;
  final $Res Function(_SyncQueueModel) _then;

/// Create a copy of SyncQueueModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableName = null,Object? recordId = null,Object? operation = null,Object? data = null,Object? retryCount = null,Object? errorMessage = freezed,Object? createdAt = freezed,}) {
  return _then(_SyncQueueModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
