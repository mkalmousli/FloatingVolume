import 'package:floating_volume/src/widgets/cool_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:floating_volume/src/bloc/permissions/bloc.dart' as bpermissions;
import 'package:floating_volume/src/bloc/permissions/event.dart'
    as epermissions;
import 'package:floating_volume/src/bloc/permissions/state.dart'
    as spermissions;
import 'package:url_launcher/url_launcher_string.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permissions")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Please grant all permissions to keep the overlay responsive and stable in the background.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const Gap(20),
          const _OverlayPermission(),
          const _NotificationPermission(),
          const _BatteryOptimizationPermission(),
          const Gap(30),
          Card(
            child: ListTile(
              title: const Text("App keeps closing or crashing?"),
              subtitle: const Text(
                "This is often caused by aggressive battery optimization. Tap to learn more on Don't Kill My App.",
              ),
              trailing: const Icon(Icons.open_in_new),
              onTap: () async {
                await launchUrlString(
                  "https://dontkillmyapp.com/",
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayPermission extends StatelessWidget {
  const _OverlayPermission();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.overlayPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: Card(
            child: ListTile(
              title: const Text("Overlay"),
              subtitle: const Text("Allow the app to draw over other apps."),
              onTap:
                  isGranted
                      ? null
                      : () {
                        context.read<bpermissions.Bloc>().add(
                          epermissions.Event.requestOverlayPermission,
                        );
                      },
              trailing: CoolSwitch(value: isGranted, width: 70),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationPermission extends StatelessWidget {
  const _NotificationPermission();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.notificationPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: Card(
            child: ListTile(
              title: const Text("Notification"),
              subtitle: const Text("Allow the app to send you notifications."),
              onTap:
                  isGranted
                      ? null
                      : () {
                        context.read<bpermissions.Bloc>().add(
                          epermissions.Event.requestNotificationPermission,
                        );
                      },
              trailing: CoolSwitch(value: isGranted, width: 70),
            ),
          ),
        );
      },
    );
  }
}

class _BatteryOptimizationPermission extends StatelessWidget {
  const _BatteryOptimizationPermission();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.batteryOptimizationPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: Card(
            child: ListTile(
              title: const Text("Battery Optimization"),
              subtitle: const Text("Allow the app to optimize battery usage."),
              onTap:
                  isGranted
                      ? null
                      : () {
                        context.read<bpermissions.Bloc>().add(
                          epermissions
                              .Event
                              .requestBatteryOptimizationPermission,
                        );
                      },
              trailing: CoolSwitch(value: isGranted, width: 70),
            ),
          ),
        );
      },
    );
  }
}
