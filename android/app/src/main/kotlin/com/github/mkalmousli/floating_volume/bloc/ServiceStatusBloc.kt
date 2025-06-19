package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import android.content.Intent
import com.github.mkalmousli.floating_volume.FloatingVolumeService
import com.github.mkalmousli.floating_volume.inMain
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest

object ServiceStatusBloc {
    private val _state = MutableStateFlow<State>(
        State.Off
    )

    val state = _state.asStateFlow()


    val event =
        MutableSharedFlow<Event>()


    sealed class State {
        object On : State()
        object Off : State()
    }

    sealed class Event {
        object Start : Event()
        object Stop : Event()
        object Toggle : Event()
    }



    suspend fun registerEvents(context: Context) {
        val scope = CoroutineScope(Dispatchers.Main)
        val intent = Intent(context, FloatingVolumeService::class.java)

        event.collectLatest {
            when (it) {
                is Event.Start -> {
                    if (_state.value is State.On) {
                        return@collectLatest
                    }

                    scope.inMain {
                        context.startService(intent)
                    }.join()

                    _state.emit(State.On)
                }
                is Event.Stop -> {
                    if (_state.value is State.Off) {
                        return@collectLatest
                    }

                    scope.inMain {
                        context.stopService(intent)
                    }.join()

                    _state.emit(State.Off)
                }
                is Event.Toggle -> {
                    val newEvent = if (_state.value is State.On) {
                        Event.Stop
                    } else {
                        Event.Start
                    }

                    event.emit(newEvent)
                }
            }
        }
    }


}
