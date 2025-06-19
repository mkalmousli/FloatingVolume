package com.github.mkalmousli.floating_volume.bloc

import android.content.Context
import android.content.res.Configuration
import android.view.OrientationEventListener
import com.github.mkalmousli.floating_volume.models.Orientation
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.collectLatest

object SystemOrientationBloc {
    private val _state =
        MutableStateFlow<State>(
            State.Uninitialized
        )

    val state = _state.asStateFlow()


    sealed class State {
        object Uninitialized : State()
        data class Initialized(val orientation: Orientation) : State()
    }


    object Utils {
        fun getCurrentOrientation(context: Context) = run {
            val v = context.resources.configuration.orientation

            if (v == Configuration.ORIENTATION_LANDSCAPE)
                Orientation.Landscape
            else
                Orientation.Portrait
        }
    }


    suspend fun initialize(context: Context) {
        val initialOrientation = Utils.getCurrentOrientation(context)
        _state.emit(
            State.Initialized(initialOrientation)
        )
    }

    suspend fun observeSystemOrientation(context: Context) {
        val flow = callbackFlow {
            val listener = object : OrientationEventListener(context) {
                override fun onOrientationChanged(ignored: Int) {
                    trySend(
                        Utils.getCurrentOrientation(context)
                    )
                }
            }

            listener.enable()
            awaitClose { listener.disable() }
        }

        flow.collectLatest {
            _state.emit(
                State.Initialized(it)
            )
        }
    }



}
