package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import com.github.mkalmousli.floating_volume.Const
import com.github.mkalmousli.floating_volume.setBoolean
import com.github.mkalmousli.floating_volume.setInt
import com.github.mkalmousli.floating_volume.sharedPrefs
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

object MaxVolumeLimitBloc {
    data class State(
        val isEnabled: Boolean,
        val limit: Int
    )

    private val _state = MutableStateFlow(State(false, 100))
    val state = _state.asStateFlow()

    suspend fun initialize(context: Context) {
        val isEnabled = context.sharedPrefs.getBoolean(
            Const.MAX_VOLUME_LIMIT_ENABLED_PREF_KEY,
            false
        )
        val limit = context.sharedPrefs.getInt(
            Const.MAX_VOLUME_LIMIT_PREF_KEY,
            100
        )
        _state.emit(State(isEnabled, limit))
    }

    suspend fun setEnabled(context: Context, enabled: Boolean) {
        context.sharedPrefs.setBoolean(Const.MAX_VOLUME_LIMIT_ENABLED_PREF_KEY, enabled)
        _state.emit(state.value.copy(isEnabled = enabled))
    }

    suspend fun setLimit(context: Context, limit: Int) {
        val normalized = limit.coerceIn(0, 100)
        context.sharedPrefs.setInt(Const.MAX_VOLUME_LIMIT_PREF_KEY, normalized)
        _state.emit(state.value.copy(limit = normalized))
    }
}
