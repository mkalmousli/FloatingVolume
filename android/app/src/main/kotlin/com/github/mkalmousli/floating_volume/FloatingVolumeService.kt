package com.github.mkalmousli.floating_volume

import android.Manifest
import android.annotation.SuppressLint
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.graphics.PixelFormat
import android.media.AudioManager
import android.os.Build
import android.util.Log
import android.view.MotionEvent
import android.view.WindowManager
import android.view.WindowManager.LayoutParams
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.github.mkalmousli.floating_volume.bloc.PositionBloc
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.bloc.VisibilityBloc
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.filterIsInstance
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class FloatingVolumeService : Service() {
    private val scope = CoroutineScope(Job())

    companion object {
        const val NOTIFICATION_ID = 1
        const val TAG = "FloatingService"
    }

    override fun onBind(intent: Intent?) = null

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    override fun onCreate() {
        super.onCreate()
    }



    private val windowManager: WindowManager by lazy {
        getSystemService(WINDOW_SERVICE) as WindowManager
    }


    private val floatingMuteView by lazy {
        FloatingVolumeView(this)
    }


    private var layoutParams =
        LayoutParams(
            LayoutParams.WRAP_CONTENT,
            LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                LayoutParams.TYPE_PHONE
            },
            LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )




    @SuppressLint("ClickableViewAccessibility")
    fun configureTouchListener() {
        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f

        floatingMuteView.handleIv.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = layoutParams.x
                    initialY = layoutParams.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    true
                }

                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - initialTouchX
                    val dy = event.rawY - initialTouchY

                    val newX = initialX + dx.toInt()
                    val newY = initialY + dy.toInt()

                    layoutParams.x = newX
                    layoutParams.y = newY

                    newInIO {
                        PositionBloc.event.emit(
                            PositionBloc.Event.UpdatePosition(
                                PositionBloc.Position(newX, newY)
                            )
                        )
                    }

                    windowManager.updateViewLayout(floatingMuteView, layoutParams)
                    true
                }

                else -> false
            }
        }
    }






    private suspend fun showFloatingMuteView() {
        Log.d(TAG, "Showing Floating Mute View")

        val position = PositionBloc.state
            .filterIsInstance<PositionBloc.State.Initialized>()
            .map { it.position }
            .first()

        withContext(Dispatchers.Main) {
            layoutParams.x = position.x
            layoutParams.y = position.y
            windowManager.addView(floatingMuteView, layoutParams)
        }
    }





    private var isFirstStart = true

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        Log.d("FloatingViewService", "onStartCommand called")

        fun createPendingIntent(action: NotificationBroadcastReceiver.Action): PendingIntent {
            val i = Intent(this@FloatingVolumeService, NotificationBroadcastReceiver::class.java)
            i.putExtra("action", action.ordinal)
            return PendingIntent.getBroadcast(
                this@FloatingVolumeService,
                100 + action.ordinal, // Unique request code for each action
                i,
                PendingIntent.FLAG_IMMUTABLE // Specify it as mutable
            )
        }

        scope.inIO {
            ServiceStatusBloc.state
                .filterIsInstance<ServiceStatusBloc.State.Off>()
                .first()

            inMain {
                stopSelf()
            }
        }


        scope.inIO {
            VisibilityBloc.state.collectLatest {
                val isVisible = it is VisibilityBloc.State.Shown

                val notification = NotificationCompat.Builder(this@FloatingVolumeService, Const.NOTIFICATION_CHANNEL_ID)
                    .setContentTitle("Floating Volume")
                    .setContentText(
                        if (isVisible) "Floating Volume is visible" else "Floating Volume is hidden"
                    )
                    .setSmallIcon(R.drawable.logo)
                    .setContentIntent(createPendingIntent(
                        NotificationBroadcastReceiver.Action.LAUNCH_MAIN_ACTIVITY
                    ))
                    .setOngoing(true)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setAutoCancel(false)
                    .setDeleteIntent(createPendingIntent(
                        NotificationBroadcastReceiver.Action.STOP
                    ))
                    .addAction(
                        android.R.color.transparent,
                        "Stop",
                        createPendingIntent(
                            NotificationBroadcastReceiver.Action.STOP
                        )
                    )
                    .addAction(
                        android.R.color.transparent,
                        if (isVisible) "Hide" else "Show",
                        createPendingIntent(
                            NotificationBroadcastReceiver.Action.TOGGLE_VISIBILITY
                        )
                    )
                    .build()


                if (isFirstStart) {
                    isFirstStart = false

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        startForeground(
                            NOTIFICATION_ID,
                            notification,
                            ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                        )
                    } else {
                        startForeground(NOTIFICATION_ID, notification)
                    }
                } else {
                    if (ActivityCompat.checkSelfPermission(
                            this@FloatingVolumeService,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        // TODO:
                        return@collectLatest
                    }

                    NotificationManagerCompat.from(this@FloatingVolumeService)
                        .notify(NOTIFICATION_ID, notification)
                }
            }
        }




        Log.d(TAG, "Starting Floating Mute View")
        scope.inIO {
            showFloatingMuteView()
            configureTouchListener()
        }



        newInIO {
            VisibilityBloc.state
                .collectLatest {
                    Log.d(TAG, "VisibilityBloc state changed: $it")
                    when (it) {
                        VisibilityBloc.State.Hidden -> {
                            newInMain {
                                floatingMuteView.visibility = android.view.View.GONE
                            }
                        }
                        VisibilityBloc.State.Shown -> {
                            newInMain {
                                floatingMuteView.visibility = android.view.View.VISIBLE
                            }
                        }
                    }
                }
        }


        scope.inIO {
            PositionBloc.state
                .filterIsInstance<PositionBloc.State.Initialized>()
                .map { it.position }
                .collectLatest { position ->
                    layoutParams.x = position.x
                    layoutParams.y = position.y
                    if (floatingMuteView.isAttachedToWindow) {
                        inMain {
                            windowManager.updateViewLayout(floatingMuteView, layoutParams)
                        }
                    }
                }
        }

        return super.onStartCommand(intent, flags, startId)
    }




    override fun onDestroy() {
        super.onDestroy()
        scope.cancel()

        val notificationManager = NotificationManagerCompat.from(this)
        notificationManager.cancel(NOTIFICATION_ID)

        if (floatingMuteView.isAttachedToWindow) {
            windowManager.removeView(floatingMuteView)
        }
    }

}