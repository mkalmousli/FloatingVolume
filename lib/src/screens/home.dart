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
import 'package:floating_volume/src/bloc/permissions/event.dart'
    as epermissions;
import 'package:floating_volume/src/bloc/permissions/state.dart'
    as spermissions;

import 'package:floating_volume/src/bloc/theme/bloc.dart' as btheme;
import 'package:floating_volume/src/bloc/theme/state.dart' as stheme;
import 'package:floating_volume/src/bloc/theme/event.dart' as etheme;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Gap(20),
            SvgPicture.asset(
              "images/logo.svg",
              width: 100,
              // colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            Gap(20),
            Center(
              child: Text(
                "Floating Volume",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Gap(50),

            BlocBuilder<bstatus.Bloc, sstatus.State>(
              builder: (context, state) {
                return GestureDetector(
                  child: CoolSwitch(value: state.isEnabled, width: 100),
                  onTap: () async {
                    final isGranted =
                        context.read<bpermissions.Bloc>().state.isGranted;

                    if (!isGranted) {
                      await nativeApi.showToast(
                        "Please grant permissions first.",
                      );

                      await context.push((_) => const PermissionsScreen());
                      return;
                    }

                    context.read<bstatus.Bloc>().add(estatus.Event.toggle);
                  },
                );
              },
            ),

            Gap(20),

            BlocBuilder<btheme.Bloc, stheme.State>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...stheme.Theme.values.map((t) {
                        final isSelected = state.theme == t;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: isSelected ? Icon(Icons.check) : null,
                            onPressed:
                                state.theme == t
                                    ? null
                                    : () => context.read<btheme.Bloc>().add(
                                      etheme.Change(t),
                                    ),
                            label: Text(t.name),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),

            ListTile(
              title: const Text("Version"),
              trailing: Text("v1.0.0"),
              subtitle: Text("03 Oct 2025"),
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
              title: const Text("Having an issue?"),
              subtitle: const Text("Report an issue on GitHub."),
              trailing: Icon(Icons.bug_report),
              onTap: () async {
                await launchUrlString(
                  "https://github.com/mkalmousli/FloatingVolume/issues",
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              title: const Text("Like this app?"),
              subtitle: const Text(
                "If you want me to work on this more, you can buy me a coffee ;)",
              ),
              trailing: Icon(Icons.tag_faces),
              onTap: () async {
                await launchUrlString(
                  "https://www.ko-fi.com/mkalmousli",
                  mode: LaunchMode.externalApplication,
                );
              },
            ),

            BlocBuilder<bpermissions.Bloc, spermissions.State>(
              builder: (context, state) {
                final Widget trailing;
                if (state.isInitialized) {
                  if (state.isGranted) {
                    trailing = Icon(Icons.check_circle);
                  } else {
                    trailing = Icon(Icons.error, color: Colors.red);
                  }
                } else {
                  trailing = CircularProgressIndicator();
                }

                final String message;
                if (state.isInitialized) {
                  if (state.isGranted) {
                    message = "Permissions are granted.";
                  } else {
                    message = "Permissions are not granted.";
                  }
                } else {
                  message = "Retrieving permissions status...";
                }

                return ListTile(
                  title: const Text("Manage Permissions"),
                  subtitle: Text(message),
                  trailing: trailing,
                  onTap: () {
                    context.push((_) => const PermissionsScreen());
                  },
                );
              },
            ),
            ListTile(
              title: const Text("License"),
              subtitle: const Text(
                "This app is licensed under the GPL-3.0 License.",
              ),
              trailing: Icon(Icons.open_in_new),
              onTap: () async {
                await launchUrlString(
                  "https://www.gnu.org/licenses/gpl-3.0.html",
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              title: const Text("Source Code"),
              subtitle: const Text("View the source code on GitHub."),
              trailing: Icon(Icons.open_in_new),
              onTap: () async {
                await launchUrlString(
                  "https://github.com/mkalmousli/FloatingVolume",
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              title: const Text("Third-Party Libraries"),
              subtitle: const Text(
                "This app would not be possible without the help of these libraries.",
              ),
              trailing: Icon(Icons.info),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
