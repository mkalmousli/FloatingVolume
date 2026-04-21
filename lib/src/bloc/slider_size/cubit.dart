import 'package:bloc/bloc.dart';
import 'package:floating_volume/src/single.dart';

class SliderSizeState {
  const SliderSizeState({
    required this.widthPercent,
    required this.heightPercent,
    required this.isCustomSizeEnabled,
    required this.isLoaded,
  });

  const SliderSizeState.initial()
    : this(
        widthPercent: 10,
        heightPercent: 40,
        isCustomSizeEnabled: false,
        isLoaded: false,
      );

  final int widthPercent;
  final int heightPercent;
  final bool isCustomSizeEnabled;
  final bool isLoaded;

  SliderSizeState copyWith({
    int? widthPercent,
    int? heightPercent,
    bool? isCustomSizeEnabled,
    bool? isLoaded,
  }) {
    return SliderSizeState(
      widthPercent: widthPercent ?? this.widthPercent,
      heightPercent: heightPercent ?? this.heightPercent,
      isCustomSizeEnabled: isCustomSizeEnabled ?? this.isCustomSizeEnabled,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SliderSizeCubit extends Cubit<SliderSizeState> {
  SliderSizeCubit() : super(const SliderSizeState.initial());

  static const int minWidth = 1;
  static const int maxWidth = 20;

  static const int minHeight = 10;
  static const int maxHeight = 80;

  Future<void> initialize() async {
    final width = await nativeApi.getSliderWidthPercent();
    final height = await nativeApi.getSliderHeightPercent();
    final isCustomSizeEnabled = await nativeApi.getCustomSizeEnabled();

    emit(
      state.copyWith(
        widthPercent: _normalizeWidth(width),
        heightPercent: _normalizeHeight(height),
        isCustomSizeEnabled: isCustomSizeEnabled,
        isLoaded: true,
      ),
    );
  }

  Future<void> updateWidth(int nextWidth) async {
    final normalized = _normalizeWidth(nextWidth);
    emit(state.copyWith(widthPercent: normalized, isLoaded: true));
    await nativeApi.setSliderWidthPercent(normalized);
  }

  Future<void> updateHeight(int nextHeight) async {
    final normalized = _normalizeHeight(nextHeight);
    emit(state.copyWith(heightPercent: normalized, isLoaded: true));
    await nativeApi.setSliderHeightPercent(normalized);
  }

  Future<void> setEnabled(bool enabled) async {
    emit(state.copyWith(isCustomSizeEnabled: enabled, isLoaded: true));
    await nativeApi.setCustomSizeEnabled(enabled);
  }

  int _normalizeWidth(int width) => width.clamp(minWidth, maxWidth);
  int _normalizeHeight(int height) => height.clamp(minHeight, maxHeight);
}
