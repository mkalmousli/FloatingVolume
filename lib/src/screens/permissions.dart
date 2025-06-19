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
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Please grant ALL permissions to ensure the app works properly:",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const Gap(20),
          _OverlayPermission(),
          _NotificationPermission(),
          _BatteryOptimizationPermission(),
          const Gap(30),

          ListTile(
            title: Text("App keeps closing or crashing?"),
            subtitle: Text(
              "This is a common issue, often caused by your device manufacturer’s battery optimization.\nTap to learn more on 'Don't Kill My App'.",
            ),
            trailing: Icon(Icons.open_in_new),
            onTap: () async {
              await launchUrlString(
                "https://dontkillmyapp.com/",
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OverlayPermission extends StatelessWidget {
  const _OverlayPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.overlayPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: ListTile(
            title: Text("Overlay"),
            subtitle: Text("Allow the app to draw over other apps."),
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
        );
      },
    );
  }
}

class _NotificationPermission extends StatelessWidget {
  const _NotificationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.notificationPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: ListTile(
            title: Text("Notification"),
            subtitle: Text("Allow the app to send you notifications."),
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
        );
      },
    );
  }
}

class _BatteryOptimizationPermission extends StatelessWidget {
  const _BatteryOptimizationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bpermissions.Bloc, spermissions.State>(
      builder: (context, state) {
        final isGranted = state.batteryOptimizationPermission.status.isGranted;

        return Opacity(
          opacity: isGranted ? 0.5 : 1,
          child: ListTile(
            title: Text("Battery Optimization"),
            subtitle: Text("Allow the app to optimize battery usage."),
            onTap:
                isGranted
                    ? null
                    : () {
                      context.read<bpermissions.Bloc>().add(
                        epermissions.Event.requestBatteryOptimizationPermission,
                      );
                    },
            trailing: CoolSwitch(value: isGranted, width: 70),
          ),
        );
      },
    );
  }
}
