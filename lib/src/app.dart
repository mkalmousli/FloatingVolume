import 'package:floating_volume/src/bloc/max_volume/cubit.dart';
import 'package:floating_volume/src/bloc/slider_size/cubit.dart';
import 'package:floating_volume/src/screens/home.dart';
import 'package:floating_volume/src/single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:floating_volume/src/bloc/permissions/bloc.dart' as bpermissions;
import 'package:floating_volume/src/bloc/permissions/event.dart'
    as epermissions;
import 'package:floating_volume/src/bloc/permissions/state.dart'
    as spermissions;

import 'package:floating_volume/src/bloc/status/bloc.dart' as bstatus;
import 'package:floating_volume/src/bloc/status/event.dart' as estatus;
import 'package:floating_volume/src/bloc/status/state.dart' as sstatus;

import 'package:floating_volume/src/bloc/theme/bloc.dart' as btheme;
import 'package:floating_volume/src/bloc/theme/event.dart' as etheme;
import 'package:floating_volume/src/bloc/theme/state.dart' as stheme;

class FloatingVolumeApp extends StatelessWidget {
  const FloatingVolumeApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create:
            (_) =>
                bpermissions.Bloc(spermissions.State())
                  ..add(epermissions.Event.initialize),
      ),
      BlocProvider(
        create:
            (_) => bstatus.Bloc(sstatus.State())..add(estatus.Event.initialize),
      ),
      BlocProvider(
        create: (_) => btheme.Bloc()..add(etheme.Event.initialize()),
      ),
      BlocProvider(create: (_) => SliderSizeCubit()..initialize()),
      BlocProvider(create: (_) => MaxVolumeCubit()..initialize()),
    ],
    child: const _FloatingVolumeAppView(),
  );
}

class _FloatingVolumeAppView extends StatelessWidget {
  const _FloatingVolumeAppView();

  ThemeData _buildTheme(ColorScheme colorScheme, bool useMaterial3) {
    return ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primaryContainer,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<btheme.Bloc, stheme.State>(
    builder: (context, state) {
      final themeMode = switch (state.theme) {
        stheme.Theme.dark => ThemeMode.dark,
        stheme.Theme.light => ThemeMode.light,
        stheme.Theme.system => ThemeMode.system,
      };

      // Sync theme to native overlay
      final isDark = switch (state.theme) {
        stheme.Theme.dark => true,
        stheme.Theme.light => false,
        stheme.Theme.system =>
          MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      };
      nativeApi.setDarkTheme(isDark);

      return MaterialApp(
        home: const HomeScreen(),
        themeMode: themeMode,
        theme: _buildTheme(
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F766E),
            brightness: Brightness.light,
          ),
          state.useMaterial3,
        ),
        darkTheme: _buildTheme(
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF7DD3C7),
            brightness: Brightness.dark,
            surface: const Color(0xFF121212),
          ),
          state.useMaterial3,
        ),
      );
    },
  );
}
