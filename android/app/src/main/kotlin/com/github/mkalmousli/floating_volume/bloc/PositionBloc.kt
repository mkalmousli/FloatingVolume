package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import android.util.Log
import com.github.mkalmousli.floating_volume.models.Orientation
import com.github.mkalmousli.floating_volume.newInMain
import com.github.mkalmousli.floating_volume.sharedPrefs
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.filterIsInstance
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

object PositionBloc {
    private val _state = MutableStateFlow<State>(
        State.Uninitialized
    )

    val state = _state.asStateFlow()

    val event = MutableSharedFlow<Event>()


    sealed class State {
        object Uninitialized : State()
        data class Initialized(val position: Position) : State()
    }

    data class Position(
        val x: Int,
        val y: Int
    )


    sealed class Event {
        data class UpdatePosition(val newPosition: Position) : Event()
    }

    private object Utils {
        private fun getSharedPreferenceKeysForOrientation(
            orientation: Orientation
        ) =
            "lastX_" + orientation.name to
            "lastY_" + orientation.name


        fun getSavedPositionForOrientation(
            context: Context,
            orientation: Orientation
        ) = run {
            val (lastXPrefKey, lastYPrefKey) =
                getSharedPreferenceKeysForOrientation(orientation)

            Position(
                context.sharedPrefs.getInt(lastXPrefKey, 0),
                context.sharedPrefs.getInt(lastYPrefKey, 0)
            )
        }

        suspend fun getSavedPositionForCurrentOrientation(context: Context) = run {
            val orientation = SystemOrientationBloc.state
                .filterIsInstance<SystemOrientationBloc.State.Initialized>()
                .map { it.orientation }
                .first()

            getSavedPositionForOrientation(context, orientation)
        }

        private suspend fun savePositionForOrientation(
            context: Context,
            orientation: Orientation,
            position: Position
        ) {
            val (lastXPrefKey, lastYPrefKey) =
                getSharedPreferenceKeysForOrientation(orientation)

            newInMain {
                context.sharedPrefs.edit()
                    .putInt(lastXPrefKey, position.x)
                    .putInt(lastYPrefKey, position.y)
                    .apply()
            }.join()

            _state.value = State.Initialized(position)
        }


        suspend fun savePosition(
            context: Context,
            position: Position
        ) {
            Log.d("PositionBloc", "Saving position: $position")
            val orientation = SystemOrientationBloc.state
                .filterIsInstance<SystemOrientationBloc.State.Initialized>()
                .map { it.orientation }
                .first()

            savePositionForOrientation(context, orientation, position)
        }
    }


    suspend fun initialize(context: Context) {
        val initialPosition =
            Utils.getSavedPositionForCurrentOrientation(context)

        val initialState = State.Initialized(
            initialPosition
        )
        _state.emit(initialState)
    }

    suspend fun handleEvents(context: Context) {
        event.collectLatest { event ->
            when (event) {
                is Event.UpdatePosition -> {
                    val newPosition = event.newPosition
                    _state.value = State.Initialized(newPosition)

                    Utils.savePosition(
                        context,
                        newPosition
                    )
                }
            }
        }
    }


    suspend fun handleOrientationChanges(context: Context) {
        SystemOrientationBloc.state
            .filterIsInstance<SystemOrientationBloc.State.Initialized>()
            .collectLatest { orientationState ->
                val orientation = orientationState.orientation
                Log.d("PositionBloc", "Orientation changed: $orientation")

                // Update position based on new orientation if needed
                val savedPosition = Utils.getSavedPositionForOrientation(
                    context,
                    orientation
                )
                _state.value = State.Initialized(savedPosition)
            }
    }
}
