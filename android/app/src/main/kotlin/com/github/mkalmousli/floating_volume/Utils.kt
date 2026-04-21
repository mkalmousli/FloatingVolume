package com.github.mkalmousli.floating_volume

import android.content.Context
import android.content.SharedPreferences
import android.util.TypedValue
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.math.roundToInt



val Context.sharedPrefs: SharedPreferences
    get() =
        getSharedPreferences(Const.SHARED_PREFS_NAME, Context.MODE_PRIVATE)

fun SharedPreferences.setInt(name: String, value: Int) =
    edit().putInt(name, value).apply()

fun SharedPreferences.setBoolean(name: String, value: Boolean) =
    edit().putBoolean(name, value).apply()

fun Context.dp(value: Int): Int =
    TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        value.toFloat(),
        resources.displayMetrics
    ).roundToInt()





fun CoroutineScope.inMain(
    block: suspend CoroutineScope.() -> Unit
): Job =
    launch(Dispatchers.Main) {
        block.invoke(this@inMain)
    }

fun CoroutineScope.inIO(
    block: suspend CoroutineScope.() -> Unit
): Job =
    launch(Dispatchers.IO) {
        block.invoke(this@inIO)
    }


fun newInMain(
    block: suspend () -> Unit
): Job =
    CoroutineScope(Dispatchers.Main).launch {
        block.invoke()
    }

fun newInIO(
    block: suspend () -> Unit
): Job =
    CoroutineScope(Dispatchers.IO).launch {
        block.invoke()
    }
