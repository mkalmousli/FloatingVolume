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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is State);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'State()';
}


}

/// @nodoc
class $StateCopyWith<$Res>  {
$StateCopyWith(State _, $Res Function(State) __);
}


/// @nodoc


class Unknown extends State {
   Unknown(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'State.unknown()';
}


}




/// @nodoc


class Known extends State {
   Known(this.theme): super._();
  

 final  Theme theme;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnownCopyWith<Known> get copyWith => _$KnownCopyWithImpl<Known>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Known&&(identical(other.theme, theme) || other.theme == theme));
}


@override
int get hashCode => Object.hash(runtimeType,theme);

@override
String toString() {
  return 'State.known(theme: $theme)';
}


}

/// @nodoc
abstract mixin class $KnownCopyWith<$Res> implements $StateCopyWith<$Res> {
  factory $KnownCopyWith(Known value, $Res Function(Known) _then) = _$KnownCopyWithImpl;
@useResult
$Res call({
 Theme theme
});




}
/// @nodoc
class _$KnownCopyWithImpl<$Res>
    implements $KnownCopyWith<$Res> {
  _$KnownCopyWithImpl(this._self, this._then);

  final Known _self;
  final $Res Function(Known) _then;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? theme = null,}) {
  return _then(Known(
null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as Theme,
  ));
}


}

// dart format on
