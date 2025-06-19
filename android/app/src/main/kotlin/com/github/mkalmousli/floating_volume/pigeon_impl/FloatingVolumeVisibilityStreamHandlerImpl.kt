package com.github.mkalmousli.floating_volume.pigeon_impl

import FloatingVolumeVisibilityStreamHandler
import PigeonEventSink
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.bloc.VisibilityBloc
import com.github.mkalmousli.floating_volume.inIO
import com.github.mkalmousli.floating_volume.inMain
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collectLatest

class FloatingVolumeVisibilityStreamHandlerImpl(
    private val scope: CoroutineScope
) : FloatingVolumeVisibilityStreamHandler() {
    private var job: Job? = null

    override fun onListen(p0: Any?, sink: PigeonEventSink<Boolean>) {
        job = scope.inIO {
            VisibilityBloc.state
                .collectLatest {
                    val visible = when (it) {
                        VisibilityBloc.State.Shown -> true
                        else -> false
                    }

                    scope.inMain {
                        sink.success(visible)
                    }
                }
        }
    }

    override fun onCancel(p0: Any?) {
        job?.cancel()
        job = null
    }
}