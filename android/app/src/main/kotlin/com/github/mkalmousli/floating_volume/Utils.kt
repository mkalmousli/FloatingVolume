package com.github.mkalmousli.floating_volume

import android.content.Context
import android.content.SharedPreferences
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch



val Context.sharedPrefs: SharedPreferences
    get() =
        getSharedPreferences(Const.SHARED_PREFS_NAME, Context.MODE_PRIVATE)

fun SharedPreferences.setInt(name: String, value: Int) =
    edit().putInt(name, value).apply()

fun SharedPreferences.setBoolean(name: String, value: Boolean) =
    edit().putBoolean(name, value).apply()





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
