// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Event {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Event()';
}


}

/// @nodoc
class $EventCopyWith<$Res>  {
$EventCopyWith(Event _, $Res Function(Event) __);
}


/// @nodoc


class Initialize extends Event {
   Initialize(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initialize);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Event.initialize()';
}


}




/// @nodoc


class Change extends Event {
   Change(this.newTheme): super._();
  

 final  s.Theme newTheme;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeCopyWith<Change> get copyWith => _$ChangeCopyWithImpl<Change>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Change&&(identical(other.newTheme, newTheme) || other.newTheme == newTheme));
}


@override
int get hashCode => Object.hash(runtimeType,newTheme);

@override
String toString() {
  return 'Event.change(newTheme: $newTheme)';
}


}

/// @nodoc
abstract mixin class $ChangeCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $ChangeCopyWith(Change value, $Res Function(Change) _then) = _$ChangeCopyWithImpl;
@useResult
$Res call({
 s.Theme newTheme
});




}
/// @nodoc
class _$ChangeCopyWithImpl<$Res>
    implements $ChangeCopyWith<$Res> {
  _$ChangeCopyWithImpl(this._self, this._then);

  final Change _self;
  final $Res Function(Change) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newTheme = null,}) {
  return _then(Change(
null == newTheme ? _self.newTheme : newTheme // ignore: cast_nullable_to_non_nullable
as s.Theme,
  ));
}


}

/// @nodoc


class ToggleMaterial3 extends Event {
   ToggleMaterial3(this.useMaterial3): super._();
  

 final  bool useMaterial3;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleMaterial3CopyWith<ToggleMaterial3> get copyWith => _$ToggleMaterial3CopyWithImpl<ToggleMaterial3>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleMaterial3&&(identical(other.useMaterial3, useMaterial3) || other.useMaterial3 == useMaterial3));
}


@override
int get hashCode => Object.hash(runtimeType,useMaterial3);

@override
String toString() {
  return 'Event.toggleMaterial3(useMaterial3: $useMaterial3)';
}


}

/// @nodoc
abstract mixin class $ToggleMaterial3CopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $ToggleMaterial3CopyWith(ToggleMaterial3 value, $Res Function(ToggleMaterial3) _then) = _$ToggleMaterial3CopyWithImpl;
@useResult
$Res call({
 bool useMaterial3
});




}
/// @nodoc
class _$ToggleMaterial3CopyWithImpl<$Res>
    implements $ToggleMaterial3CopyWith<$Res> {
  _$ToggleMaterial3CopyWithImpl(this._self, this._then);

  final ToggleMaterial3 _self;
  final $Res Function(ToggleMaterial3) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? useMaterial3 = null,}) {
  return _then(ToggleMaterial3(
null == useMaterial3 ? _self.useMaterial3 : useMaterial3 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
