import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'state.freezed.dart';

enum Operation { none, initializing }

@freezed
abstract class State with _$State {
  const factory State({
    @Default(PermissionState()) PermissionState overlayPermission,
    @Default(PermissionState()) PermissionState notificationPermission,
    @Default(PermissionState()) PermissionState batteryOptimizationPermission,
    @Default(Operation.none) Operation operation,
  }) = _State;

  const State._();

  bool get isInitialized =>
      overlayPermission.isInitialized &&
      notificationPermission.isInitialized &&
      batteryOptimizationPermission.isInitialized;

  bool get isGranted =>
      overlayPermission.status.isGranted &&
      notificationPermission.status.isGranted &&
      batteryOptimizationPermission.status.isGranted;
}

enum PermissionOperation { none, requestingPermission }

@freezed
abstract class PermissionState with _$PermissionState {
  const factory PermissionState({
    @Default(false) bool isInitialized,
    @Default(PermissionStatus.denied) PermissionStatus status,
    @Default(PermissionOperation.none) PermissionOperation operation,
  }) = _PermissionState;
}
