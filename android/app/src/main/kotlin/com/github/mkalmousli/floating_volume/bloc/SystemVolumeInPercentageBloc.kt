package com.github.mkalmousli.floating_volume.bloc

import android.media.AudioManager
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.filterIsInstance
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

object SystemVolumeInPercentageBloc {
    private val _state = MutableStateFlow<State>(
        State.Uninitialized
    )

    val state = _state.asStateFlow()


    sealed class State {
        object Uninitialized : State()
        data class Initialized(val percentage: Int) : State()
    }


    suspend fun initialize(audioManager: AudioManager) {
        val initialVolume =
            SystemVolumeBloc.state
                .filterIsInstance<SystemVolumeBloc.State.Initialized>()
                .map { it.volume }
                .first()

        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

        val percentage = if (maxVolume > 0) {
            (initialVolume * 100) / maxVolume
        } else {
            0
        }

        _state.emit(
            State.Initialized(percentage)
        )
    }


    suspend fun listenToVolumeChange(audioManager: AudioManager) {
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

        SystemVolumeBloc.state
            .filterIsInstance<SystemVolumeBloc.State.Initialized>()
            .map { it.volume }
            .collect {
                val percentage = if (maxVolume > 0) {
                    (it * 100) / maxVolume
                } else {
                    0
                }

                _state.emit(
                    State.Initialized(percentage)
                )
            }
    }


}
