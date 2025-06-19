import 'package:bloc/bloc.dart' as a;
import 'package:floating_volume/generated/native_api.g.dart';
import 'package:floating_volume/generated/native_events.g.dart';
import 'package:floating_volume/src/single.dart';

import 'event.dart' as e;
import 'state.dart' as s;

class Bloc extends a.Bloc<e.Event, s.State> {
  Bloc(super.initialState) {
    on<e.Event>((event, emit) async {
      switch (event) {
        case e.Event.initialize:
          Future<void> handleServiceStatus() async {
            await for (final isEnabled in serviceStatus()) {
              emit(state.copyWith(isEnabled: isEnabled));
            }
          }

          Future<void> handleFloatingVolumeVisibility() async {
            await for (final isVisible in floatingVolumeVisibility()) {
              emit(state.copyWith(isVisible: isVisible));
            }
          }

          await Future.wait([
            handleServiceStatus(),
            handleFloatingVolumeVisibility(),
          ]);
          break;

        case e.Event.enable:
          emit(state.copyWith(operation: s.Operation.enabling));

          await nativeApi.startService();
          emit(state.copyWith(isEnabled: true));

          await nativeApi.showFloatingVolume();
          emit(state.copyWith(isVisible: true, operation: s.Operation.none));
          break;

        case e.Event.disable:
          emit(state.copyWith(operation: s.Operation.disabling));

          await nativeApi.hideFloatingVolume();
          emit(state.copyWith(isVisible: false));

          await nativeApi.stopService();
          emit(state.copyWith(isEnabled: false, operation: s.Operation.none));
          break;

        case e.Event.toggle:
          if (state.isEnabled) {
            add(e.Event.disable);
          } else {
            add(e.Event.enable);
          }
          break;
      }
    });
  }
}
