package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import com.github.mkalmousli.floating_volume.Const
import com.github.mkalmousli.floating_volume.setInt
import com.github.mkalmousli.floating_volume.sharedPrefs
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

object SliderSizeBloc {
    data class State(
        val widthPercent: Int,
        val heightPercent: Int,
        val isCustomSizeEnabled: Boolean
    )

    private val _state = MutableStateFlow(
        State(
            Const.DEFAULT_SLIDER_WIDTH_PERCENT,
            Const.DEFAULT_SLIDER_HEIGHT_PERCENT,
            false
        )
    )

    val state = _state.asStateFlow()

    fun normalizeWidth(width: Int): Int =
        width.coerceIn(Const.MIN_SLIDER_WIDTH_PERCENT, Const.MAX_SLIDER_WIDTH_PERCENT)

    fun normalizeHeight(height: Int): Int =
        height.coerceIn(Const.MIN_SLIDER_HEIGHT_PERCENT, Const.MAX_SLIDER_HEIGHT_PERCENT)

    suspend fun initialize(context: Context) {
        val savedWidth = context.sharedPrefs.getInt(
            Const.SLIDER_WIDTH_PERCENT_PREF_KEY,
            Const.DEFAULT_SLIDER_WIDTH_PERCENT
        )
        val savedHeight = context.sharedPrefs.getInt(
            Const.SLIDER_HEIGHT_PERCENT_PREF_KEY,
            Const.DEFAULT_SLIDER_HEIGHT_PERCENT
        )
        val isEnabled = context.sharedPrefs.getBoolean(
            Const.CUSTOM_SIZE_ENABLED_PREF_KEY,
            false
        )

        _state.emit(
            State(
                normalizeWidth(savedWidth),
                normalizeHeight(savedHeight),
                isEnabled
            )
        )
    }

    suspend fun setWidthPercent(context: Context, width: Int) {
        val normalized = normalizeWidth(width)
        context.sharedPrefs.setInt(Const.SLIDER_WIDTH_PERCENT_PREF_KEY, normalized)
        _state.emit(state.value.copy(widthPercent = normalized))
    }

    suspend fun setHeightPercent(context: Context, height: Int) {
        val normalized = normalizeHeight(height)
        context.sharedPrefs.setInt(Const.SLIDER_HEIGHT_PERCENT_PREF_KEY, normalized)
        _state.emit(state.value.copy(heightPercent = normalized))
    }

    suspend fun setEnabled(context: Context, enabled: Boolean) {
        context.sharedPrefs.setBoolean(Const.CUSTOM_SIZE_ENABLED_PREF_KEY, enabled)
        _state.emit(state.value.copy(isCustomSizeEnabled = enabled))
    }
}
