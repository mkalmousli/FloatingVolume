import 'package:bloc/bloc.dart' as a;
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart' as e;
import 'state.dart' as s;

class Bloc extends a.Bloc<e.Event, s.State> {
  Bloc([s.State? initialState]) : super(initialState ?? s.State.unknown()) {
    on<e.Initialize>((event, emit) async {
      final (theme, useMaterial3) = await _get();
      emit(s.State.known(theme, useMaterial3));
    });

    on<e.Change>((event, emit) async {
      final newTheme = event.newTheme;
      await _setTheme(newTheme);
      emit(s.State.known(newTheme, state.useMaterial3));
    });

    on<e.ToggleMaterial3>((event, emit) async {
      final useMaterial3 = event.useMaterial3;
      await _setMaterial3(useMaterial3);
      emit(s.State.known(state.theme, useMaterial3));
    });
  }

  static Future<(s.Theme, bool)> _get() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString("theme");
    final useMaterial3 = prefs.getBool("use_material_3") ?? true;

    final theme =
        s.Theme.values.where((t) => t.name == themeName).firstOrNull ??
        s.Theme.system;

    return (theme, useMaterial3);
  }

  static Future<void> _setTheme(s.Theme newTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", newTheme.name);
  }

  static Future<void> _setMaterial3(bool useMaterial3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("use_material_3", useMaterial3);
  }
}
