package com.github.mkalmousli.floating_volume.bloc

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.util.Log
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.collectLatest

object SystemVolumeBloc {
    private val _state = MutableStateFlow<State>(
        State.Uninitialized
    )

    val state = _state.asStateFlow()


    val event = MutableSharedFlow<Event>()


    sealed class State {
        object Uninitialized : State()
        data class Initialized(val volume: Int) : State()
    }

    sealed class Event {
        data class SetVolume(val volume: Int) : Event()
        object Mute : Event()
    }


    suspend fun observeSystemVolume(context: Context) {
        val flow = callbackFlow {
            val receiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {
                    when (intent.getIntExtra("android.media.EXTRA_VOLUME_STREAM_TYPE", 0)) {
                        STREAM -> trySend(
                            intent.getIntExtra(
                                "android.media.EXTRA_VOLUME_STREAM_VALUE",
                                0
                            )
                        )
                    }
                }
            }

            context.registerReceiver(
                receiver,
                IntentFilter("android.media.VOLUME_CHANGED_ACTION")
            )
            awaitClose { context.unregisterReceiver(receiver) }
        }


        flow.collectLatest {
            _state.emit(
                State.Initialized(it)
            )
        }
    }


    private const val STREAM = AudioManager.STREAM_MUSIC


    suspend fun initialize(context: Context) {
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val currentVolume = audioManager.getStreamVolume(STREAM)

        _state.emit(
            State.Initialized(currentVolume)
        )
        Log.d("SystemVolumeBloc", "Initialized with volume: $currentVolume")
    }

    suspend fun handleEvents(context: Context) {
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        suspend fun setVolume(volume: Int) {
            audioManager.setStreamVolume(
                STREAM,
                volume,
                AudioManager.FLAG_PLAY_SOUND
            )

            _state.emit(
                State.Initialized(volume)
            )
        }


        event.collectLatest {
            when (it) {
                is Event.SetVolume -> setVolume(it.volume)
                Event.Mute -> setVolume(0)
            }
        }
    }

}
