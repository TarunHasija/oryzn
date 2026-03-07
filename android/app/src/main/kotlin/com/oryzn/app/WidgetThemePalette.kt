package com.oryzn.app

import android.content.Context
import android.content.res.Configuration
import android.graphics.Color

data class WidgetThemePalette(
    val surfacePrimary: Int,
    val textIconPrimary: Int,
    val textIconSecondary: Int,
    val surfaceTertiary: Int,
    val activeDay: Int,
)

fun widgetPalette(context: Context): WidgetThemePalette {
  val nightMode = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
  val isDark = nightMode == Configuration.UI_MODE_NIGHT_YES

  return if (isDark) {
    WidgetThemePalette(
        surfacePrimary = Color.parseColor("#1C1C1C"),
        textIconPrimary = Color.WHITE,
        textIconSecondary = Color.parseColor("#747373"),
        surfaceTertiary = Color.parseColor("#444444"),
        activeDay = Color.parseColor("#FF4400"),
    )
  } else {
    WidgetThemePalette(
        surfacePrimary = Color.WHITE,
        textIconPrimary = Color.parseColor("#1C1C1C"),
        textIconSecondary = Color.parseColor("#ABABAB"),
        surfaceTertiary = Color.parseColor("#D5D5D5"),
        activeDay = Color.parseColor("#FF4400"),
    )
  }
}
