package com.github.mkalmousli.floating_volume.bloc

import android.util.Log
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow


private const val TAG = "VisibilityBloc"

object VisibilityBloc {
    private val _state =
        MutableStateFlow<State>(
            State.Hidden
        )

    val state = _state.asStateFlow()

    val event =
        MutableSharedFlow<Event>()


    sealed class State {
        object Shown : State()
        object Hidden : State()
    }

    sealed class Event {
        object Show : Event()
        object Hide : Event()
        object Toggle : Event()
    }


    suspend fun handleServiceStatusChanges() {
        ServiceStatusBloc.state.collect { serviceState ->
            when (serviceState) {
                is ServiceStatusBloc.State.On -> {
                    Log.d(TAG, "Floating service is ON")
                    _state.emit(State.Shown)
                }
                else -> {
                    Log.d(TAG, "Floating service is OFF or CRASHED")
                    _state.emit(State.Hidden)
                }
            }
        }
    }

    suspend fun registerEvents() {
        Log.d(TAG, "Registering event observers")
        event.collect {
            Log.d(TAG, "Received event: $it")
            when (it) {
                Event.Show -> {
                    val isServiceRunning = ServiceStatusBloc.state.value is ServiceStatusBloc.State.On

                    if (!isServiceRunning) {
                        throw IllegalStateException("Service must be running to show the mode.")
                    }

                    Log.d(TAG, "Showing mode")
                    _state.emit(State.Shown)
                }


                Event.Hide -> {
                    Log.d(TAG, "Hiding mode")
                    _state.emit(State.Hidden)
                }

                Event.Toggle -> {
                    Log.d(TAG, "Toggling mode")

                    val newState = when (_state.value) {
                        State.Hidden -> State.Shown
                        State.Shown -> State.Hidden
                    }
                    _state.emit(newState)
                }
            }
        }
    }


}
