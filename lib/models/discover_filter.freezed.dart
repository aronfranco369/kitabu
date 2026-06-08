// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverFilter {

 String get year; String get dj; String get country; String get type;
/// Create a copy of DiscoverFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverFilterCopyWith<DiscoverFilter> get copyWith => _$DiscoverFilterCopyWithImpl<DiscoverFilter>(this as DiscoverFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverFilter&&(identical(other.year, year) || other.year == year)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.country, country) || other.country == country)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,year,dj,country,type);

@override
String toString() {
  return 'DiscoverFilter(year: $year, dj: $dj, country: $country, type: $type)';
}


}

/// @nodoc
abstract mixin class $DiscoverFilterCopyWith<$Res>  {
  factory $DiscoverFilterCopyWith(DiscoverFilter value, $Res Function(DiscoverFilter) _then) = _$DiscoverFilterCopyWithImpl;
@useResult
$Res call({
 String year, String dj, String country, String type
});




}
/// @nodoc
class _$DiscoverFilterCopyWithImpl<$Res>
    implements $DiscoverFilterCopyWith<$Res> {
  _$DiscoverFilterCopyWithImpl(this._self, this._then);

  final DiscoverFilter _self;
  final $Res Function(DiscoverFilter) _then;

/// Create a copy of DiscoverFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? dj = null,Object? country = null,Object? type = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,dj: null == dj ? _self.dj : dj // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverFilter].
extension DiscoverFilterPatterns on DiscoverFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverFilter value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverFilter value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String year,  String dj,  String country,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverFilter() when $default != null:
return $default(_that.year,_that.dj,_that.country,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String year,  String dj,  String country,  String type)  $default,) {final _that = this;
switch (_that) {
case _DiscoverFilter():
return $default(_that.year,_that.dj,_that.country,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String year,  String dj,  String country,  String type)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverFilter() when $default != null:
return $default(_that.year,_that.dj,_that.country,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverFilter implements DiscoverFilter {
  const _DiscoverFilter({this.year = 'All', this.dj = 'All', this.country = 'All', this.type = 'All'});
  

@override@JsonKey() final  String year;
@override@JsonKey() final  String dj;
@override@JsonKey() final  String country;
@override@JsonKey() final  String type;

/// Create a copy of DiscoverFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverFilterCopyWith<_DiscoverFilter> get copyWith => __$DiscoverFilterCopyWithImpl<_DiscoverFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverFilter&&(identical(other.year, year) || other.year == year)&&(identical(other.dj, dj) || other.dj == dj)&&(identical(other.country, country) || other.country == country)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,year,dj,country,type);

@override
String toString() {
  return 'DiscoverFilter(year: $year, dj: $dj, country: $country, type: $type)';
}


}

/// @nodoc
abstract mixin class _$DiscoverFilterCopyWith<$Res> implements $DiscoverFilterCopyWith<$Res> {
  factory _$DiscoverFilterCopyWith(_DiscoverFilter value, $Res Function(_DiscoverFilter) _then) = __$DiscoverFilterCopyWithImpl;
@override @useResult
$Res call({
 String year, String dj, String country, String type
});




}
/// @nodoc
class __$DiscoverFilterCopyWithImpl<$Res>
    implements _$DiscoverFilterCopyWith<$Res> {
  __$DiscoverFilterCopyWithImpl(this._self, this._then);

  final _DiscoverFilter _self;
  final $Res Function(_DiscoverFilter) _then;

/// Create a copy of DiscoverFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? dj = null,Object? country = null,Object? type = null,}) {
  return _then(_DiscoverFilter(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,dj: null == dj ? _self.dj : dj // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
