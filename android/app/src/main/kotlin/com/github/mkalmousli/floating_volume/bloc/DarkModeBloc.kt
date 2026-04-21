package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import com.github.mkalmousli.floating_volume.Const
import com.github.mkalmousli.floating_volume.setBoolean
import com.github.mkalmousli.floating_volume.sharedPrefs
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

object DarkModeBloc {
    private val _state = MutableStateFlow(true)
    val state = _state.asStateFlow()

    suspend fun initialize(context: Context) {
        val isDark = context.sharedPrefs.getBoolean(
            Const.DARK_MODE_PREF_KEY,
            true
        )
        _state.emit(isDark)
    }

    suspend fun set(context: Context, isDark: Boolean) {
        context.sharedPrefs.setBoolean(Const.DARK_MODE_PREF_KEY, isDark)
        _state.emit(isDark)
    }
}
