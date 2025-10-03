import 'package:bloc/bloc.dart' as a;
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart' as e;
import 'state.dart' as s;

class Bloc extends a.Bloc<e.Event, s.State> {
  Bloc([s.State? initialState]) : super(initialState ?? s.State.unknown()) {
    on<e.Initialize>((event, emit) async {
      final theme = await _get();
      emit(s.State.known(theme));
    });

    on<e.Change>((event, emit) async {
      final newTheme = event.newTheme;
      await _set(newTheme);
      emit(s.State.known(newTheme));
    });
  }

  static Future<s.Theme> _get() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString("theme");

    return s.Theme.values.where((t) => t.name == themeName).firstOrNull ??
        s.Theme.system;
  }

  static Future<void> _set(s.Theme newTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", newTheme.name);
  }
}
