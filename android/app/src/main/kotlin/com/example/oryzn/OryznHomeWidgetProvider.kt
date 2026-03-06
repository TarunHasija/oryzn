package com.example.oryzn

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Shader
import android.os.Bundle
import android.util.TypedValue
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import java.util.concurrent.TimeUnit
import kotlin.math.max
import kotlin.math.min

class OryznHomeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views = RemoteViews(context.packageName, R.layout.oryzn_home_widget)
      val dateText = widgetData.getString(KEY_DATE_TEXT, formatDate())
      val daysLeftText =
          widgetData.getString(KEY_DAYS_LEFT_TEXT, "${daysLeftInYear()} days left")

      views.setTextViewText(R.id.widget_date, dateText)
      views.setTextViewText(R.id.widget_days_left, daysLeftText)
      views.setOnClickPendingIntent(
          R.id.widget_root,
          HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
      )

      val options = appWidgetManager.getAppWidgetOptions(widgetId)
      val (widthPx, heightPx) = resolveWidgetSizePx(context, options)
      val dotsHeightPx = max((heightPx * 0.58f).toInt(), dpToPx(context, 70f))
      val dots = createDotPatternBitmap(widthPx, dotsHeightPx)
      views.setImageViewBitmap(R.id.widget_dots, dots)

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  override fun onAppWidgetOptionsChanged(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
      newOptions: Bundle,
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    onUpdate(
        context,
        appWidgetManager,
        intArrayOf(appWidgetId),
        HomeWidgetPlugin.getData(context),
    )
  }

  private fun resolveWidgetSizePx(context: Context, options: Bundle): Pair<Int, Int> {
    val minWidthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 280)
    val minHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 120)
    val widthPx = dpToPx(context, minWidthDp.toFloat()).coerceAtLeast(dpToPx(context, 240f))
    val heightPx = dpToPx(context, minHeightDp.toFloat()).coerceAtLeast(dpToPx(context, 120f))
    return widthPx to heightPx
  }

  private fun createDotPatternBitmap(widthPx: Int, heightPx: Int): Bitmap {
    val safeWidth = widthPx.coerceAtLeast(240)
    val safeHeight = heightPx.coerceAtLeast(72)
    val bitmap = Bitmap.createBitmap(safeWidth, safeHeight, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val columns = 36
    val rows = 9
    val stepX = safeWidth.toFloat() / (columns + 1)
    val stepY = safeHeight.toFloat() / (rows + 1)
    val radius = max(2f, min(stepX, stepY) * 0.28f)

    val paint =
        Paint(Paint.ANTI_ALIAS_FLAG).apply {
          style = Paint.Style.FILL
          color = Color.WHITE
        }

    for (row in 0 until rows) {
      val y = stepY * (row + 1)
      val rowProgress = row.toFloat() / rows.toFloat()
      paint.alpha = (255f * (1f - rowProgress * 0.82f)).toInt().coerceIn(24, 255)
      val offsetX = if (row % 2 == 0) 0f else stepX * 0.5f
      var column = 0
      while (column < columns) {
        val x = stepX * (column + 1) + offsetX
        if (x > safeWidth - radius) break
        canvas.drawCircle(x, y, radius, paint)
        column++
      }
    }

    val fadePaint =
        Paint().apply {
          shader =
              LinearGradient(
                  0f,
                  safeHeight * 0.52f,
                  0f,
                  safeHeight.toFloat(),
                  Color.TRANSPARENT,
                  Color.argb(230, 0, 0, 0),
                  Shader.TileMode.CLAMP,
              )
        }
    canvas.drawRect(0f, 0f, safeWidth.toFloat(), safeHeight.toFloat(), fadePaint)

    return bitmap
  }

  private fun formatDate(): String {
    val formatter = SimpleDateFormat("EEEE, d MMMM yyyy", Locale.getDefault())
    return formatter.format(Calendar.getInstance().time)
  }

  private fun daysLeftInYear(): Int {
    val now = Calendar.getInstance()
    val endOfYear =
        Calendar.getInstance().apply {
          set(Calendar.MONTH, Calendar.DECEMBER)
          set(Calendar.DAY_OF_MONTH, 31)
          set(Calendar.HOUR_OF_DAY, 23)
          set(Calendar.MINUTE, 59)
          set(Calendar.SECOND, 59)
          set(Calendar.MILLISECOND, 999)
        }
    val diffMillis = (endOfYear.timeInMillis - now.timeInMillis).coerceAtLeast(0L)
    return TimeUnit.MILLISECONDS.toDays(diffMillis).toInt()
  }

  private fun dpToPx(context: Context, dp: Float): Int {
    return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            dp,
            context.resources.displayMetrics,
        )
        .toInt()
  }

  companion object {
    private const val KEY_DATE_TEXT = "widget_date_text"
    private const val KEY_DAYS_LEFT_TEXT = "widget_days_left_text"
  }
}
