import 'package:bloc/bloc.dart' as a;
import 'package:floating_volume/generated/native_api.g.dart';
import 'package:floating_volume/src/single.dart';
import 'package:permission_handler/permission_handler.dart';

import 'event.dart' as e;
import 'state.dart' as s;

Stream<PermissionStatus> _createPermissionStream(
  Permission permission, {
  Duration pollingInterval = const Duration(seconds: 1),
}) async* {
  yield await permission.status;
  while (true) {
    await Future.delayed(pollingInterval);
    yield await permission.status;
  }
}

class Bloc extends a.Bloc<e.Event, s.State> {
  Bloc(super.initialState) {
    on<e.Event>((event, emit) async {
      switch (event) {
        case e.Event.initialize:
          emit(state.copyWith(operation: s.Operation.initializing));
          final overlayPermission = await Permission.systemAlertWindow.status;
          final notificationPermission = await Permission.notification.status;
          final batteryOptimizationPermission =
              await Permission.ignoreBatteryOptimizations.status;
          emit(
            state.copyWith(
              operation: s.Operation.none,
              overlayPermission: state.overlayPermission.copyWith(
                isInitialized: true,
                status: overlayPermission,
              ),
              notificationPermission: state.notificationPermission.copyWith(
                isInitialized: true,
                status: notificationPermission,
              ),
              batteryOptimizationPermission: state.batteryOptimizationPermission
                  .copyWith(
                    isInitialized: true,
                    status: batteryOptimizationPermission,
                  ),
            ),
          );

          Future<void> observePermission(
            Permission permission,
            Function(PermissionStatus v) onStatusChanged,
          ) async {
            final stream = _createPermissionStream(
              permission,
              pollingInterval: Duration(seconds: 5),
            );
            await for (final status in stream) {
              onStatusChanged(status);
            }
          }

          await Future.wait([
            observePermission(
              Permission.systemAlertWindow,
              (status) => emit(
                state.copyWith(
                  overlayPermission: state.overlayPermission.copyWith(
                    status: status,
                  ),
                ),
              ),
            ),
            observePermission(
              Permission.notification,
              (status) => emit(
                state.copyWith(
                  notificationPermission: state.notificationPermission.copyWith(
                    status: status,
                  ),
                ),
              ),
            ),
            observePermission(
              Permission.ignoreBatteryOptimizations,
              (status) => emit(
                state.copyWith(
                  batteryOptimizationPermission: state
                      .batteryOptimizationPermission
                      .copyWith(status: status),
                ),
              ),
            ),
          ]);

          _createPermissionStream(Permission.systemAlertWindow).listen((
            status,
          ) {
            emit(
              state.copyWith(
                overlayPermission: state.overlayPermission.copyWith(
                  status: status,
                ),
              ),
            );
          });
          break;

        case e.Event.requestOverlayPermission:
          emit(
            state.copyWith(
              overlayPermission: state.overlayPermission.copyWith(
                operation: s.PermissionOperation.requestingPermission,
              ),
            ),
          );

          final overlayPermission = await requestPermission(
            Permission.systemAlertWindow,
            state.overlayPermission.status,
          );

          emit(
            state.copyWith(
              overlayPermission: state.overlayPermission.copyWith(
                status: overlayPermission,
                operation: s.PermissionOperation.none,
              ),
            ),
          );

          break;

        case e.Event.requestNotificationPermission:
          emit(
            state.copyWith(
              notificationPermission: state.notificationPermission.copyWith(
                operation: s.PermissionOperation.requestingPermission,
              ),
            ),
          );

          final notificationPermission = await requestPermission(
            Permission.notification,
            state.notificationPermission.status,
          );

          emit(
            state.copyWith(
              notificationPermission: state.notificationPermission.copyWith(
                status: notificationPermission,
                operation: s.PermissionOperation.none,
              ),
            ),
          );

          break;

        case e.Event.requestBatteryOptimizationPermission:
          emit(
            state.copyWith(
              batteryOptimizationPermission: state.batteryOptimizationPermission
                  .copyWith(
                    operation: s.PermissionOperation.requestingPermission,
                  ),
            ),
          );

          final batteryOptimizationPermission = await requestPermission(
            Permission.ignoreBatteryOptimizations,
            state.batteryOptimizationPermission.status,
          );

          emit(
            state.copyWith(
              batteryOptimizationPermission: state.batteryOptimizationPermission
                  .copyWith(
                    status: batteryOptimizationPermission,
                    operation: s.PermissionOperation.none,
                  ),
            ),
          );
          break;
      }
    });
  }
}

Future<PermissionStatus> requestPermission(
  Permission permission,
  PermissionStatus status,
) async {
  if (status.isGranted) {
    return status;
  }

  if (status.isPermanentlyDenied) {
    await nativeApi.showToast(
      "${permission.toString().split('.').last} permission is permanently denied. Please enable it in settings.",
      ToastDuration.long,
    );
    final isOpened = await openAppSettings();
    if (!isOpened) {
      return status;
    }

    Future<PermissionStatus> listenToPermission() async {
      await for (final newStatus in _createPermissionStream(
        permission,
        pollingInterval: const Duration(milliseconds: 500),
      ).timeout(const Duration(minutes: 10))) {
        return newStatus;
      }

      return status;
    }

    return listenToPermission();
  }

  return permission.request();
}
