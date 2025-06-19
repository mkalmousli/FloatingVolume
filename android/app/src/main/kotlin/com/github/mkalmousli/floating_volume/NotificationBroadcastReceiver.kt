package com.github.mkalmousli.floating_volume

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.bloc.VisibilityBloc
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class NotificationBroadcastReceiver : BroadcastReceiver() {
    enum class Action {
        TOGGLE_VISIBILITY,
        STOP,
        LAUNCH_MAIN_ACTIVITY
    }

    private val scope = CoroutineScope(Dispatchers.IO)

    override fun onReceive(context: Context?, intent: Intent?) {
        val actionId = intent?.getIntExtra("action", -1)
        val action = Action.values().find { it.ordinal == actionId }
            ?: return


        when (action) {
            Action.TOGGLE_VISIBILITY -> {
                scope.launch {
                    VisibilityBloc.event.emit(
                        VisibilityBloc.Event.Toggle
                    )
                }
            }

            Action.STOP -> {
                scope.launch {
                    ServiceStatusBloc.event.emit(
                        ServiceStatusBloc.Event.Stop
                    )
                }
            }

            Action.LAUNCH_MAIN_ACTIVITY -> {
                // launch the main activity if not already running
                val i = Intent(context, MainActivity::class.java)
                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context?.startActivity(i)
            }
        }
    }
}