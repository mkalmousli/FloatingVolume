import 'package:freezed_annotation/freezed_annotation.dart';
part 'state.freezed.dart';

enum Operation { none, enabling, disabling }

enum Theme { dark, light, system }

@freezed
sealed class State with _$State {
  const State._();
  factory State.unknown() = Unknown;
  factory State.known(Theme theme, bool useMaterial3) = Known;

  Theme get theme => switch (this) {
    Unknown() => Theme.system,
    Known v => v.theme,
  };

  bool get useMaterial3 => switch (this) {
    Unknown() => true,
    Known v => v.useMaterial3,
  };
}
