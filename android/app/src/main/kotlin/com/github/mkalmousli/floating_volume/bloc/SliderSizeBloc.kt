package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import com.github.mkalmousli.floating_volume.Const
import com.github.mkalmousli.floating_volume.setInt
import com.github.mkalmousli.floating_volume.sharedPrefs
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

object SliderSizeBloc {
    private val _state = MutableStateFlow(Const.DEFAULT_SLIDER_SIZE_DP)

    val state = _state.asStateFlow()

    fun normalize(size: Int): Int =
        size.coerceIn(Const.MIN_SLIDER_SIZE_DP, Const.MAX_SLIDER_SIZE_DP)

    suspend fun initialize(context: Context) {
        val savedSize = context.sharedPrefs.getInt(
            Const.SLIDER_SIZE_PREF_KEY,
            Const.DEFAULT_SLIDER_SIZE_DP
        )

        _state.emit(normalize(savedSize))
    }

    suspend fun set(context: Context, size: Int) {
        val normalizedSize = normalize(size)
        context.sharedPrefs.setInt(Const.SLIDER_SIZE_PREF_KEY, normalizedSize)
        _state.emit(normalizedSize)
    }
}
