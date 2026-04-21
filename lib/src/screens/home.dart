import 'package:floating_volume/src/app_info.dart';
import 'package:floating_volume/src/bloc/max_volume/cubit.dart';
import 'package:floating_volume/src/bloc/slider_size/cubit.dart';
import 'package:floating_volume/src/ext.dart';
import 'package:floating_volume/src/single.dart';
import 'package:floating_volume/src/widgets/cool_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'permissions.dart';

import 'package:floating_volume/src/bloc/status/bloc.dart' as bstatus;
import 'package:floating_volume/src/bloc/status/event.dart' as estatus;
import 'package:floating_volume/src/bloc/status/state.dart' as sstatus;

import 'package:floating_volume/src/bloc/permissions/bloc.dart' as bpermissions;
import 'package:floating_volume/src/bloc/permissions/state.dart'
    as spermissions;

import 'package:floating_volume/src/bloc/theme/bloc.dart' as btheme;
import 'package:floating_volume/src/bloc/theme/event.dart' as etheme;
import 'package:floating_volume/src/bloc/theme/state.dart' as stheme;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: const [
            _HeroCard(),
            Gap(12),
            _ServiceCard(),
            Gap(12),
            _AppearanceCard(),
            Gap(12),
            _MaxVolumeCard(),
            Gap(12),
            _PermissionsCard(),
            Gap(12),
            _LinksCard(),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [colorScheme.primaryContainer, colorScheme.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SvgPicture.asset("images/logo.svg"),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Floating Volume",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "A persistent system volume slider.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<bstatus.Bloc, sstatus.State>(
      builder: (context, state) {
        final isBusy = state.operation != sstatus.Operation.none;
        final isEnabled = state.isEnabled;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isBusy
                ? null
                : () async {
                    final isGranted =
                        context.read<bpermissions.Bloc>().state.isGranted;

                    if (!isGranted) {
                      await nativeApi.showToast("Grant permissions first.");
                      if (context.mounted) {
                        await context.push((_) => const PermissionsScreen());
                      }
                      return;
                    }

                    context.read<bstatus.Bloc>().add(estatus.Event.toggle);
                  },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Overlay",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isEnabled ? "Running" : "Stopped",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: isBusy ? 0.6 : 1,
                    child: CoolSwitch(value: isEnabled, width: 80),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appearance",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(12),
            BlocBuilder<btheme.Bloc, stheme.State>(
              builder: (context, state) {
                return Column(
                  children: [
                    SegmentedButton<stheme.Theme>(
                      segments: const [
                        ButtonSegment(
                          value: stheme.Theme.system,
                          icon: Icon(Icons.brightness_auto_outlined, size: 20),
                          label: Text("Auto"),
                        ),
                        ButtonSegment(
                          value: stheme.Theme.light,
                          icon: Icon(Icons.light_mode_outlined, size: 20),
                          label: Text("Light"),
                        ),
                        ButtonSegment(
                          value: stheme.Theme.dark,
                          icon: Icon(Icons.dark_mode_outlined, size: 20),
                          label: Text("Dark"),
                        ),
                      ],
                      selected: {state.theme},
                      onSelectionChanged: (selection) {
                        final selectedTheme = selection.first;
                        if (selectedTheme != state.theme) {
                          context.read<btheme.Bloc>().add(
                            etheme.Change(selectedTheme),
                          );
                        }
                      },
                    ),
                    const Gap(8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Use Material 3"),
                      value: state.useMaterial3,
                      onChanged: (value) {
                        context.read<btheme.Bloc>().add(
                          etheme.ToggleMaterial3(value),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            BlocBuilder<SliderSizeCubit, SliderSizeState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Custom Size (%)"),
                      value: state.isCustomSizeEnabled,
                      onChanged: (value) {
                        context.read<SliderSizeCubit>().setEnabled(value);
                      },
                    ),
                    if (state.isCustomSizeEnabled) ...[
                      _SizeSlider(
                        label: "Width",
                        value: state.widthPercent.toDouble(),
                        min: SliderSizeCubit.minWidth.toDouble(),
                        max: SliderSizeCubit.maxWidth.toDouble(),
                        onChanged: state.isLoaded
                            ? (v) =>
                                context.read<SliderSizeCubit>().updateWidth(
                                  v.round(),
                                )
                            : null,
                        unit: "%",
                      ),
                      _SizeSlider(
                        label: "Height",
                        value: state.heightPercent.toDouble(),
                        min: SliderSizeCubit.minHeight.toDouble(),
                        max: SliderSizeCubit.maxHeight.toDouble(),
                        onChanged: state.isLoaded
                            ? (v) =>
                                context.read<SliderSizeCubit>().updateHeight(
                                  v.round(),
                                )
                            : null,
                        unit: "%",
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MaxVolumeCard extends StatelessWidget {
  const _MaxVolumeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<MaxVolumeCubit, MaxVolumeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Max Volume Limit",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Enable Limit"),
                  value: state.isEnabled,
                  onChanged: (value) {
                    context.read<MaxVolumeCubit>().setEnabled(value);
                  },
                ),
                if (state.isEnabled)
                  _SizeSlider(
                    label: "Limit",
                    value: state.limit.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (v) =>
                        context.read<MaxVolumeCubit>().setLimit(v.round()),
                    unit: "%",
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SizeSlider extends StatelessWidget {
  const _SizeSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.unit = "dp",
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const Spacer(),
            Text("${value.round()}$unit", style: theme.textTheme.bodySmall),
          ],
        ),
        Slider(
          min: min,
          max: max,
          divisions: (max - min).round() > 0 ? (max - min).round() : 1,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<bpermissions.Bloc, spermissions.State>(
        builder: (context, state) {
          final isGranted = state.isGranted;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            dense: true,
            title: const Text("Permissions"),
            subtitle: Text(
              isGranted ? "All granted" : "Attention required",
              style: TextStyle(
                color: isGranted ? null : Theme.of(context).colorScheme.error,
              ),
            ),
            trailing: Icon(
              isGranted ? Icons.check_circle_outline : Icons.error_outline,
              size: 20,
              color: isGranted
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
            onTap: () {
              context.push((_) => const PermissionsScreen());
            },
          );
        },
      ),
    );
  }
}

class _LinksCard extends StatelessWidget {
  const _LinksCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: const Text("Version"),
            subtitle: const Text(appReleaseDate),
            trailing: const Text("v$appVersion"),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.favorite, color: Colors.red, size: 20),
            title: const Text("Support development"),
            subtitle: const Text("Buy me a coffee on Ko-fi"),
            onTap: () async {
              await launchUrlString(
                "https://www.ko-fi.com/mkalmousli",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.language, size: 20),
            title: const Text("Developer Website"),
            subtitle: const Text("mkalmousli.dev"),
            onTap: () async {
              await launchUrlString(
                "https://mkalmousli.dev",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text("Source code"),
            subtitle: const Text("GitHub"),
            trailing: const Icon(Icons.code, size: 20),
            onTap: () async {
              await launchUrlString(
                "https://github.com/mkalmousli/FloatingVolume",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text("Third-party libraries"),
            trailing: const Icon(Icons.info_outline, size: 20),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }
}
