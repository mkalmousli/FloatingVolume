import 'package:floating_volume/src/app_info.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: const [
            _HeroCard(),
            Gap(16),
            _ServiceCard(),
            Gap(16),
            _AppearanceCard(),
            Gap(16),
            _PermissionsCard(),
            Gap(16),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [colorScheme.primaryContainer, colorScheme.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(24),
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      "A persistent system volume slider that stays one swipe away.",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Chip(
                avatar: Icon(Icons.tune, size: 18),
                label: Text("Resizable slider"),
              ),
              Chip(
                avatar: Icon(Icons.palette_outlined, size: 18),
                label: Text("Material 3 refresh"),
              ),
            ],
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<bstatus.Bloc, sstatus.State>(
          builder: (context, state) {
            final isBusy = state.operation != sstatus.Operation.none;
            final isEnabled = state.isEnabled;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overlay",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  isEnabled
                      ? "The floating slider is running and ready."
                      : "Start the service to keep volume control on screen.",
                  style: theme.textTheme.bodyMedium,
                ),
                const Gap(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: isBusy
                          ? null
                          : () async {
                              final isGranted = context
                                  .read<bpermissions.Bloc>()
                                  .state
                                  .isGranted;

                              if (!isGranted) {
                                await nativeApi.showToast(
                                  "Please grant permissions first.",
                                );

                                if (context.mounted) {
                                  await context.push(
                                    (_) => const PermissionsScreen(),
                                  );
                                }
                                return;
                              }

                              context.read<bstatus.Bloc>().add(
                                estatus.Event.toggle,
                              );
                            },
                      child: Opacity(
                        opacity: isBusy ? 0.6 : 1,
                        child: CoolSwitch(value: isEnabled, width: 104),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: isBusy
                            ? null
                            : () {
                                context.push((_) => const PermissionsScreen());
                              },
                        icon: const Icon(Icons.shield_outlined),
                        label: const Text("Permissions"),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appearance",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(18),
            BlocBuilder<btheme.Bloc, stheme.State>(
              builder: (context, state) {
                return SegmentedButton<stheme.Theme>(
                  segments: const [
                    ButtonSegment(
                      value: stheme.Theme.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text("System"),
                    ),
                    ButtonSegment(
                      value: stheme.Theme.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text("Light"),
                    ),
                    ButtonSegment(
                      value: stheme.Theme.dark,
                      icon: Icon(Icons.dark_mode_outlined),
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
                );
              },
            ),
            const Gap(20),
            BlocBuilder<SliderSizeCubit, SliderSizeState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Slider size",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text("${state.size} dp"),
                      ],
                    ),
                    const Gap(4),
                    Text(
                      "Make the overlay wider for easier control on larger or denser screens.",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Slider(
                      min: SliderSizeCubit.minSize.toDouble(),
                      max: SliderSizeCubit.maxSize.toDouble(),
                      divisions:
                          SliderSizeCubit.maxSize - SliderSizeCubit.minSize,
                      label: "${state.size} dp",
                      value: state.size.toDouble(),
                      onChanged: state.isLoaded
                          ? (value) {
                              context.read<SliderSizeCubit>().update(
                                value.round(),
                              );
                            }
                          : null,
                    ),
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

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<bpermissions.Bloc, spermissions.State>(
        builder: (context, state) {
          final trailing = !state.isInitialized
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Icon(
                  state.isGranted ? Icons.check_circle : Icons.error,
                  color: state.isGranted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                );

          final message = !state.isInitialized
              ? "Retrieving permissions status..."
              : state.isGranted
              ? "All required permissions are granted."
              : "Some required permissions still need attention.";

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            title: const Text("Permission status"),
            subtitle: Text(message),
            trailing: trailing,
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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Version"),
            subtitle: const Text(appReleaseDate),
            trailing: const Text("v$appVersion"),
          ),
          ListTile(
            title: const Text("Created by @mkalmousli"),
            subtitle: const Text("https://mkalmousli.dev"),
            trailing: SvgPicture.asset("images/mk.svg"),
            onTap: () async {
              await launchUrlString(
                "https://mkalmousli.dev",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            title: const Text("Report an issue"),
            subtitle: const Text("Open GitHub issues"),
            trailing: const Icon(Icons.bug_report_outlined),
            onTap: () async {
              await launchUrlString(
                "https://github.com/mkalmousli/FloatingVolume/issues",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            title: const Text("Support development"),
            subtitle: const Text("Buy me a coffee on Ko-fi"),
            trailing: const Icon(Icons.favorite_border),
            onTap: () async {
              await launchUrlString(
                "https://www.ko-fi.com/mkalmousli",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            title: const Text("License"),
            subtitle: const Text("GPL-3.0"),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              await launchUrlString(
                "https://www.gnu.org/licenses/gpl-3.0.html",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            title: const Text("Source code"),
            subtitle: const Text("View the project on GitHub"),
            trailing: const Icon(Icons.code),
            onTap: () async {
              await launchUrlString(
                "https://github.com/mkalmousli/FloatingVolume",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            title: const Text("Third-party libraries"),
            subtitle: const Text("Review licenses for dependencies"),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }
}
