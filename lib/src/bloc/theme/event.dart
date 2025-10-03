import 'package:freezed_annotation/freezed_annotation.dart';
import 'state.dart' as s;

part 'event.freezed.dart';

@freezed
sealed class Event with _$Event {
  const Event._();
  factory Event.initialize() = Initialize;
  factory Event.change(s.Theme newTheme) = Change;
}
