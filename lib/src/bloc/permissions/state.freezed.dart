// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$State {

 PermissionState get overlayPermission; PermissionState get notificationPermission; PermissionState get batteryOptimizationPermission; Operation get operation;
/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StateCopyWith<State> get copyWith => _$StateCopyWithImpl<State>(this as State, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is State&&(identical(other.overlayPermission, overlayPermission) || other.overlayPermission == overlayPermission)&&(identical(other.notificationPermission, notificationPermission) || other.notificationPermission == notificationPermission)&&(identical(other.batteryOptimizationPermission, batteryOptimizationPermission) || other.batteryOptimizationPermission == batteryOptimizationPermission)&&(identical(other.operation, operation) || other.operation == operation));
}


@override
int get hashCode => Object.hash(runtimeType,overlayPermission,notificationPermission,batteryOptimizationPermission,operation);

@override
String toString() {
  return 'State(overlayPermission: $overlayPermission, notificationPermission: $notificationPermission, batteryOptimizationPermission: $batteryOptimizationPermission, operation: $operation)';
}


}

/// @nodoc
abstract mixin class $StateCopyWith<$Res>  {
  factory $StateCopyWith(State value, $Res Function(State) _then) = _$StateCopyWithImpl;
@useResult
$Res call({
 PermissionState overlayPermission, PermissionState notificationPermission, PermissionState batteryOptimizationPermission, Operation operation
});


$PermissionStateCopyWith<$Res> get overlayPermission;$PermissionStateCopyWith<$Res> get notificationPermission;$PermissionStateCopyWith<$Res> get batteryOptimizationPermission;

}
/// @nodoc
class _$StateCopyWithImpl<$Res>
    implements $StateCopyWith<$Res> {
  _$StateCopyWithImpl(this._self, this._then);

  final State _self;
  final $Res Function(State) _then;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? overlayPermission = null,Object? notificationPermission = null,Object? batteryOptimizationPermission = null,Object? operation = null,}) {
  return _then(_self.copyWith(
overlayPermission: null == overlayPermission ? _self.overlayPermission : overlayPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,notificationPermission: null == notificationPermission ? _self.notificationPermission : notificationPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,batteryOptimizationPermission: null == batteryOptimizationPermission ? _self.batteryOptimizationPermission : batteryOptimizationPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as Operation,
  ));
}
/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get overlayPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.overlayPermission, (value) {
    return _then(_self.copyWith(overlayPermission: value));
  });
}/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get notificationPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.notificationPermission, (value) {
    return _then(_self.copyWith(notificationPermission: value));
  });
}/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get batteryOptimizationPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.batteryOptimizationPermission, (value) {
    return _then(_self.copyWith(batteryOptimizationPermission: value));
  });
}
}


/// @nodoc


class _State extends State {
  const _State({this.overlayPermission = const PermissionState(), this.notificationPermission = const PermissionState(), this.batteryOptimizationPermission = const PermissionState(), this.operation = Operation.none}): super._();
  

@override@JsonKey() final  PermissionState overlayPermission;
@override@JsonKey() final  PermissionState notificationPermission;
@override@JsonKey() final  PermissionState batteryOptimizationPermission;
@override@JsonKey() final  Operation operation;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StateCopyWith<_State> get copyWith => __$StateCopyWithImpl<_State>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _State&&(identical(other.overlayPermission, overlayPermission) || other.overlayPermission == overlayPermission)&&(identical(other.notificationPermission, notificationPermission) || other.notificationPermission == notificationPermission)&&(identical(other.batteryOptimizationPermission, batteryOptimizationPermission) || other.batteryOptimizationPermission == batteryOptimizationPermission)&&(identical(other.operation, operation) || other.operation == operation));
}


@override
int get hashCode => Object.hash(runtimeType,overlayPermission,notificationPermission,batteryOptimizationPermission,operation);

@override
String toString() {
  return 'State(overlayPermission: $overlayPermission, notificationPermission: $notificationPermission, batteryOptimizationPermission: $batteryOptimizationPermission, operation: $operation)';
}


}

/// @nodoc
abstract mixin class _$StateCopyWith<$Res> implements $StateCopyWith<$Res> {
  factory _$StateCopyWith(_State value, $Res Function(_State) _then) = __$StateCopyWithImpl;
@override @useResult
$Res call({
 PermissionState overlayPermission, PermissionState notificationPermission, PermissionState batteryOptimizationPermission, Operation operation
});


@override $PermissionStateCopyWith<$Res> get overlayPermission;@override $PermissionStateCopyWith<$Res> get notificationPermission;@override $PermissionStateCopyWith<$Res> get batteryOptimizationPermission;

}
/// @nodoc
class __$StateCopyWithImpl<$Res>
    implements _$StateCopyWith<$Res> {
  __$StateCopyWithImpl(this._self, this._then);

  final _State _self;
  final $Res Function(_State) _then;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? overlayPermission = null,Object? notificationPermission = null,Object? batteryOptimizationPermission = null,Object? operation = null,}) {
  return _then(_State(
overlayPermission: null == overlayPermission ? _self.overlayPermission : overlayPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,notificationPermission: null == notificationPermission ? _self.notificationPermission : notificationPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,batteryOptimizationPermission: null == batteryOptimizationPermission ? _self.batteryOptimizationPermission : batteryOptimizationPermission // ignore: cast_nullable_to_non_nullable
as PermissionState,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as Operation,
  ));
}

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get overlayPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.overlayPermission, (value) {
    return _then(_self.copyWith(overlayPermission: value));
  });
}/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get notificationPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.notificationPermission, (value) {
    return _then(_self.copyWith(notificationPermission: value));
  });
}/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<$Res> get batteryOptimizationPermission {
  
  return $PermissionStateCopyWith<$Res>(_self.batteryOptimizationPermission, (value) {
    return _then(_self.copyWith(batteryOptimizationPermission: value));
  });
}
}

/// @nodoc
mixin _$PermissionState {

 bool get isInitialized; PermissionStatus get status; PermissionOperation get operation;
/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionStateCopyWith<PermissionState> get copyWith => _$PermissionStateCopyWithImpl<PermissionState>(this as PermissionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.status, status) || other.status == status)&&(identical(other.operation, operation) || other.operation == operation));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,status,operation);

@override
String toString() {
  return 'PermissionState(isInitialized: $isInitialized, status: $status, operation: $operation)';
}


}

/// @nodoc
abstract mixin class $PermissionStateCopyWith<$Res>  {
  factory $PermissionStateCopyWith(PermissionState value, $Res Function(PermissionState) _then) = _$PermissionStateCopyWithImpl;
@useResult
$Res call({
 bool isInitialized, PermissionStatus status, PermissionOperation operation
});




}
/// @nodoc
class _$PermissionStateCopyWithImpl<$Res>
    implements $PermissionStateCopyWith<$Res> {
  _$PermissionStateCopyWithImpl(this._self, this._then);

  final PermissionState _self;
  final $Res Function(PermissionState) _then;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isInitialized = null,Object? status = null,Object? operation = null,}) {
  return _then(_self.copyWith(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PermissionStatus,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as PermissionOperation,
  ));
}

}


/// @nodoc


class _PermissionState implements PermissionState {
  const _PermissionState({this.isInitialized = false, this.status = PermissionStatus.denied, this.operation = PermissionOperation.none});
  

@override@JsonKey() final  bool isInitialized;
@override@JsonKey() final  PermissionStatus status;
@override@JsonKey() final  PermissionOperation operation;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionStateCopyWith<_PermissionState> get copyWith => __$PermissionStateCopyWithImpl<_PermissionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionState&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.status, status) || other.status == status)&&(identical(other.operation, operation) || other.operation == operation));
}


@override
int get hashCode => Object.hash(runtimeType,isInitialized,status,operation);

@override
String toString() {
  return 'PermissionState(isInitialized: $isInitialized, status: $status, operation: $operation)';
}


}

/// @nodoc
abstract mixin class _$PermissionStateCopyWith<$Res> implements $PermissionStateCopyWith<$Res> {
  factory _$PermissionStateCopyWith(_PermissionState value, $Res Function(_PermissionState) _then) = __$PermissionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isInitialized, PermissionStatus status, PermissionOperation operation
});




}
/// @nodoc
class __$PermissionStateCopyWithImpl<$Res>
    implements _$PermissionStateCopyWith<$Res> {
  __$PermissionStateCopyWithImpl(this._self, this._then);

  final _PermissionState _self;
  final $Res Function(_PermissionState) _then;

/// Create a copy of PermissionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isInitialized = null,Object? status = null,Object? operation = null,}) {
  return _then(_PermissionState(
isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PermissionStatus,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as PermissionOperation,
  ));
}


}

// dart format on
