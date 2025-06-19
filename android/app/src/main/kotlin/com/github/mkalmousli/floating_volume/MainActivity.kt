package com.github.mkalmousli.floating_volume

import NativeApi
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import com.github.mkalmousli.floating_volume.bloc.PositionBloc
import com.github.mkalmousli.floating_volume.bloc.ServiceStatusBloc
import com.github.mkalmousli.floating_volume.bloc.SystemOrientationBloc
import com.github.mkalmousli.floating_volume.bloc.SystemVolumeBloc
import com.github.mkalmousli.floating_volume.bloc.SystemVolumeInPercentageBloc
import com.github.mkalmousli.floating_volume.bloc.VisibilityBloc
import com.github.mkalmousli.floating_volume.pigeon_impl.FloatingVolumeVisibilityStreamHandlerImpl
import com.github.mkalmousli.floating_volume.pigeon_impl.NativeApiImpl
import com.github.mkalmousli.floating_volume.pigeon_impl.ServiceStatusStreamHandlerImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O)
            return

        val name = "Floating Volume Channel"
        val descriptionText = "Channel for Floating Volume notifications"
        val importance = NotificationManager.IMPORTANCE_DEFAULT
        val channel = NotificationChannel(Const.NOTIFICATION_CHANNEL_ID, name, importance).apply {
            description = descriptionText
        }
        val notificationManager: NotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        val c = this
        val audioManager = c.getSystemService(AUDIO_SERVICE) as android.media.AudioManager

        lifecycleScope.apply {
            /**
             * Create the notification channel for the service.
             * This is required for Android O and above to show notifications.
             */
            inMain {
                createNotificationChannel()
            }


            /**
             * [SystemVolumeBloc] is responsible for managing the system volume.
             */
            // Initialize the SystemVolumeBloc and start observing system volume changes.
            inIO {
                SystemVolumeBloc.initialize(c)
                SystemVolumeBloc.observeSystemVolume(c)
            }
            /// Handle events for the SystemVolumeBloc.
            inIO {
                SystemVolumeBloc.handleEvents(c)
            }

            /**
             * [SystemVolumeInPercentageBloc]
             */
            inIO {
                SystemVolumeInPercentageBloc.initialize(audioManager)
                SystemVolumeInPercentageBloc.listenToVolumeChange(audioManager)
            }


            /**
             * [SystemOrientationBloc]
             */
            inIO {
                SystemOrientationBloc.initialize(c)
            }
            inIO {
                SystemOrientationBloc.observeSystemOrientation(c)
            }



            /**
             * [PositionBloc]
             */
            inIO {
                PositionBloc.initialize(c)
            }
            inIO {
                PositionBloc.handleOrientationChanges(c)
            }
            inIO {
                PositionBloc.handleEvents(c)
            }





            /**
             * [ServiceStatusBloc]
             */
            inIO {
                ServiceStatusBloc.registerEvents(c)
            }




            /**
             * [VisibilityBloc]
             */
            inIO {
                VisibilityBloc.registerEvents()
            }
            inIO {
                VisibilityBloc.handleServiceStatusChanges()
            }
        }

    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        lifecycleScope.apply {
            inMain {
                NativeApi.setUp(
                    flutterEngine.dartExecutor.binaryMessenger,
                    NativeApiImpl(context, lifecycleScope)
                )
            }

            inMain {
                ServiceStatusStreamHandler.register(
                    flutterEngine.dartExecutor.binaryMessenger,
                    ServiceStatusStreamHandlerImpl(lifecycleScope)
                )
            }

            inMain {
                FloatingVolumeVisibilityStreamHandler.register(
                    flutterEngine.dartExecutor.binaryMessenger,
                    FloatingVolumeVisibilityStreamHandlerImpl(lifecycleScope)
                )
            }
        }
    }
}

