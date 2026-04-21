import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/generated/native_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/dev/flutter/floating_volume/NativeApi.g.kt',
    kotlinOptions: KotlinOptions(),
    dartPackageName: 'floating_volume',
  ),
)
@HostApi()
abstract class NativeApi {
  ///
  /// Starts the floating volume service.
  /// This method starts the android service that manages the floating volume widget.
  ///
  @async
  void startService();

  ///
  /// Stops the floating volume service.
  /// This method stops the android service that manages the floating volume widget.
  ///
  @async
  void stopService();

  ///
  /// Hides the floating volume widget.
  /// This method hides the floating volume widget, but does not stop the service.
  ///
  @async
  void hideFloatingVolume();

  ///
  /// Shows the floating volume widget.
  /// This method shows the floating volume widget, if it is hidden.
  ///
  @async
  void showFloatingVolume();

  ///
  /// Changes the maximum volume level.
  ///
  @async
  void setMaxVolume(int maxVolume);

  ///
  /// Changes the minimum volume level.
  ///
  @async
  void setMinVolume(int minVolume);

  ///
  /// Returns the saved slider width in percentage (0-100).
  ///
  @async
  int getSliderWidthPercent();

  ///
  /// Updates the slider width in percentage (0-100).
  ///
  @async
  void setSliderWidthPercent(int widthPercent);

  ///
  /// Returns the saved slider height in percentage (0-100).
  ///
  @async
  int getSliderHeightPercent();

  ///
  /// Updates the slider height in percentage (0-100).
  ///
  @async
  void setSliderHeightPercent(int heightPercent);

  ///
  /// Returns if custom size is enabled.
  ///
  @async
  bool getCustomSizeEnabled();

  ///
  /// Enables or disables custom slider size.
  ///
  @async
  void setCustomSizeEnabled(bool enabled);

  ///
  /// Updates the theme mode of the floating volume widget.
  ///
  @async
  void setDarkTheme(bool isDark);

  ///
  /// Returns if the maximum volume limit is enabled.
  ///
  @async
  bool getMaxVolumeLimitEnabled();

  ///
  /// Enables or disables the maximum volume limit.
  ///
  @async
  void setMaxVolumeLimitEnabled(bool enabled);

  ///
  /// Returns the saved maximum volume limit.
  ///
  @async
  int getMaxVolumeLimit();

  ///
  /// Updates the maximum volume limit.
  ///
  @async
  void setMaxVolumeLimit(int maxVolume);

  ///
  /// Show a toast
  ///
  @async
  void showToast(
    String message, [
    ToastDuration duration = ToastDuration.short,
  ]);
}

enum ToastDuration { short, long }
