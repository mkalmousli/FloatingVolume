package com.github.mkalmousli.floating_volume

import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.Gravity
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.SeekBar
import androidx.core.view.marginTop
import androidx.core.view.updateMargins
import com.github.mkalmousli.floating_volume.bloc.SystemVolumeBloc
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.filterIsInstance
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlin.math.min

class FloatingVolumeView(
    context: Context
) : LinearLayout(context) {

    //TODO: Use other lifecycle-aware coroutine scope
    private val scope = CoroutineScope(Dispatchers.Main)

    private val audioManager by lazy {
        context.getSystemService(Context.AUDIO_SERVICE) as android.media.AudioManager
    }

    private val slider by lazy {
        CoolSlider(context).apply {
            min.value = 0
            max.value = audioManager.getStreamMaxVolume(android.media.AudioManager.STREAM_MUSIC)
            setBackgroundColor(
                0xFFCCCCCC.toInt()
            )

            layoutParams = LayoutParams(
                50,
                300
            )
            orientation.value = CoolSlider.Orientation.Vertical


            scope.inIO {
                val initialVolume = SystemVolumeBloc.state
                    .filterIsInstance<SystemVolumeBloc.State.Initialized>()
                    .map { it.volume }
                    .first()
                value.value = initialVolume


                scope.inIO {
                    SystemVolumeBloc.state
                        .filterIsInstance<SystemVolumeBloc.State.Initialized>()
                        .map { it.volume }
                        .collectLatest {
                            value.value = it
                        }
                }

                scope.inIO {
                    value.collectLatest {
                        SystemVolumeBloc.event.emit(
                            SystemVolumeBloc.Event.SetVolume(it)
                        )
                    }
                }
            }
        }
    }

    val handleIv by lazy {
        ImageView(context).apply {
            setImageResource(R.drawable.move) // Replace with your drawable resource
            alpha = 0.5f

            val size = min(
                50,
                50
            )
            layoutParams = LayoutParams(
                size,
                size
            ).apply {
                updateMargins(
                    top = 10
                )
            }
        }
    }

    init {
        orientation = VERTICAL
        gravity = Gravity.CENTER
        addView(slider)
        addView(handleIv)
    }
}