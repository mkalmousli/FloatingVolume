package com.github.mkalmousli.floating_volume.pigeon_impl

import PigeonEventSink
import ServiceStatusStreamHandler
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.inIO
import com.github.mkalmousli.floating_volume.inMain
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collectLatest

class ServiceStatusStreamHandlerImpl(
    private val scope: CoroutineScope
) : ServiceStatusStreamHandler() {
    private var job: Job? = null

    override fun onListen(p0: Any?, sink: PigeonEventSink<Boolean>) {
        job = scope.inIO {
            ServiceStatusBloc.state
                .collectLatest {
                    val visible = when (it) {
                        ServiceStatusBloc.State.On -> true
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