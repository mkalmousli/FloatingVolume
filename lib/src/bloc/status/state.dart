import 'package:freezed_annotation/freezed_annotation.dart';
part 'state.freezed.dart';

enum Operation { none, enabling, disabling }

@freezed
abstract class State with _$State {
  const factory State({
    @Default(false) bool isEnabled,
    @Default(false) bool isVisible,
    @Default(Operation.none) Operation operation,
  }) = _State;

  const State._();
}
