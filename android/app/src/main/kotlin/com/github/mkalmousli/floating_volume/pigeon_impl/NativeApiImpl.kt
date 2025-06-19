package com.github.mkalmousli.floating_volume.pigeon_impl

import NativeApi
import ToastDuration
import android.content.Context
import android.widget.Toast
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.bloc.VisibilityBloc
import com.github.mkalmousli.floating_volume.inIO
import com.github.mkalmousli.floating_volume.inMain
import kotlinx.coroutines.CoroutineScope


class NativeApiImpl(
    private val context: Context,
    private val scope: CoroutineScope
) : NativeApi {
    override fun startService(callback: (Result<Unit>) -> Unit) {
        scope.inIO {
            ServiceStatusBloc.event.emit(
                ServiceStatusBloc.Event.Start
            )
            inMain {
                callback(Result.success(Unit))
            }
        }
    }

    override fun stopService(callback: (Result<Unit>) -> Unit) {
        scope.inIO {
            ServiceStatusBloc.event.emit(
                ServiceStatusBloc.Event.Stop
            )
            inMain {
                callback(Result.success(Unit))
            }
        }
    }

    override fun hideFloatingVolume(callback: (Result<Unit>) -> Unit) {
        scope.inIO {
            VisibilityBloc.event.emit(
                VisibilityBloc.Event.Hide
            )
            inMain {
                callback(Result.success(Unit))
            }
        }
    }

    override fun showFloatingVolume(callback: (Result<Unit>) -> Unit) {
        scope.inIO {
            VisibilityBloc.event.emit(
                VisibilityBloc.Event.Show
            )
            inMain {
                callback(Result.success(Unit))
            }
        }
    }

    override fun setMaxVolume(maxVolume: Long, callback: (Result<Unit>) -> Unit) {
        scope.inIO {
//            SystemVolumeBloc
        }
    }

    override fun setMinVolume(minVolume: Long, callback: (Result<Unit>) -> Unit) {
//        TODO("Not yet implemented")
    }

    override fun showToast(
        message: String,
        duration: ToastDuration,
        callback: (Result<Unit>) -> Unit
    ) {
        scope.inMain {
            try {
                Toast.makeText(
                    context,
                    message,
                    when (duration) {
                        ToastDuration.SHORT -> Toast.LENGTH_SHORT
                        ToastDuration.LONG -> Toast.LENGTH_LONG
                    }
                ).show()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }
}