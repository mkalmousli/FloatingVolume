import 'package:bloc/bloc.dart';
import 'package:floating_volume/src/single.dart';

class SliderSizeState {
  const SliderSizeState({required this.size, required this.isLoaded});

  const SliderSizeState.initial() : this(size: 56, isLoaded: false);

  final int size;
  final bool isLoaded;

  SliderSizeState copyWith({int? size, bool? isLoaded}) {
    return SliderSizeState(
      size: size ?? this.size,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SliderSizeCubit extends Cubit<SliderSizeState> {
  SliderSizeCubit() : super(const SliderSizeState.initial());

  static const int minSize = 36;
  static const int maxSize = 92;

  Future<void> initialize() async {
    final savedSize = await nativeApi.getSliderSize();
    emit(state.copyWith(size: _normalize(savedSize), isLoaded: true));
  }

  Future<void> update(int nextSize) async {
    final normalizedSize = _normalize(nextSize);
    emit(state.copyWith(size: normalizedSize, isLoaded: true));
    await nativeApi.setSliderSize(normalizedSize);
  }

  int _normalize(int size) => size.clamp(minSize, maxSize);
}
