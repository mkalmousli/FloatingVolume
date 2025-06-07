import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/native_events.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/dev/flutter/floating_volume/NativeEvents.g.kt',
    kotlinOptions: KotlinOptions(includeErrorClass: false),
    dartPackageName: 'floating_volume',
  ),
)
@EventChannelApi()
abstract class NativeEvents {
  ///
  /// This is a stream that listens to the android service,
  /// also when wether the service is running or not.
  ///
  bool serviceStatus();

  ///
  /// This is a stream that listens to the visibility of the floating volume widget.
  /// Also wether its visible or not.
  ///
  bool floatingVolumeVisibility();
}
