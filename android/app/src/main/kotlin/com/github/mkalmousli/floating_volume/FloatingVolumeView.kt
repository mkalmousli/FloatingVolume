package com.github.mkalmousli.floating_volume

import android.content.Context
import android.view.Gravity
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.core.view.marginTop
import androidx.core.view.updateMargins
import androidx.core.view.updateLayoutParams
import com.github.mkalmousli.floating_volume.bloc.DarkModeBloc
import com.github.mkalmousli.floating_volume.bloc.MaxVolumeLimitBloc
import com.github.mkalmousli.floating_volume.bloc.SliderSizeBloc
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
                context.dp(Const.DEFAULT_SLIDER_WIDTH_DP),
                context.dp(56)
            )
            layoutParams = LayoutParams(
                size,
                size
            ).apply {
                updateMargins(
                    top = context.dp(12)
                )
            }
        }
    }

    private fun applySliderSize(state: SliderSizeBloc.State) {
        val displayMetrics = context.resources.displayMetrics
        val screenWidth = displayMetrics.widthPixels
        val screenHeight = displayMetrics.heightPixels

        val width = if (state.isCustomSizeEnabled) {
            (screenWidth * state.widthPercent / 100)
        } else {
            context.dp(56)
        }

        val height = if (state.isCustomSizeEnabled) {
            (screenHeight * state.heightPercent / 100)
        } else {
            context.dp(320)
        }

        val handleSize = maxOf(width, context.dp(56))

        slider.updateLayoutParams<LayoutParams> {
            this.width = width
            this.height = height
        }

        handleIv.updateLayoutParams<LayoutParams> {
            this.width = handleSize
            this.height = handleSize
            updateMargins(top = context.dp(12))
        }
    }

    private fun applyTheme(isDark: Boolean) {
        if (isDark) {
            slider.setBackgroundColor(0xFF121212.toInt())
            slider.progressView.setBackgroundColor(0xFF4CAF50.toInt())
        } else {
            slider.setBackgroundColor(0xFFFFFFFF.toInt())
            slider.progressView.setBackgroundColor(0xFF0F766E.toInt())
        }
    }

    init {
        orientation = VERTICAL
        gravity = Gravity.CENTER
        addView(slider)
        addView(handleIv)

        scope.inIO {
            SliderSizeBloc.state.collectLatest { state ->
                inMain {
                    applySliderSize(state)
                }
            }
        }

        scope.inIO {
            DarkModeBloc.state.collectLatest { isDark ->
                inMain {
                    applyTheme(isDark)
                }
            }
        }

        scope.inIO {
            MaxVolumeLimitBloc.state.collectLatest { limitState ->
                val maxVolume = audioManager.getStreamMaxVolume(android.media.AudioManager.STREAM_MUSIC)
                val limit = if (limitState.isEnabled) {
                    (maxVolume * limitState.limit / 100)
                } else {
                    maxVolume
                }
                inMain {
                    slider.max.value = limit
                }
            }
        }
    }
}
