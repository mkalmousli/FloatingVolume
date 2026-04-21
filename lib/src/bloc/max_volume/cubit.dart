import 'package:bloc/bloc.dart';
import 'package:floating_volume/src/single.dart';

class MaxVolumeState {
  const MaxVolumeState({
    required this.isEnabled,
    required this.limit,
    required this.isLoaded,
  });

  const MaxVolumeState.initial()
    : this(isEnabled: false, limit: 100, isLoaded: false);

  final bool isEnabled;
  final int limit;
  final bool isLoaded;

  MaxVolumeState copyWith({bool? isEnabled, int? limit, bool? isLoaded}) {
    return MaxVolumeState(
      isEnabled: isEnabled ?? this.isEnabled,
      limit: limit ?? this.limit,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class MaxVolumeCubit extends Cubit<MaxVolumeState> {
  MaxVolumeCubit() : super(const MaxVolumeState.initial());

  Future<void> initialize() async {
    final isEnabled = await nativeApi.getMaxVolumeLimitEnabled();
    final limit = await nativeApi.getMaxVolumeLimit();
    emit(state.copyWith(isEnabled: isEnabled, limit: limit, isLoaded: true));
  }

  Future<void> setEnabled(bool enabled) async {
    emit(state.copyWith(isEnabled: enabled, isLoaded: true));
    await nativeApi.setMaxVolumeLimitEnabled(enabled);
  }

  Future<void> setLimit(int limit) async {
    emit(state.copyWith(limit: limit, isLoaded: true));
    await nativeApi.setMaxVolumeLimit(limit);
  }
}
