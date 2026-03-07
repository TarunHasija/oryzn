package com.oryzn.app

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Bundle
import android.util.TypedValue
import android.widget.RemoteViews
import androidx.core.content.res.ResourcesCompat
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import kotlin.math.min

class Clock2x2WidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    renderWidgets(context, appWidgetManager, appWidgetIds)
  }

  override fun onAppWidgetOptionsChanged(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
      newOptions: Bundle,
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    renderWidgets(context, appWidgetManager, intArrayOf(appWidgetId))
  }

  override fun onReceive(context: Context, intent: Intent) {
    super.onReceive(context, intent)
    when (intent.action) {
      Intent.ACTION_DATE_CHANGED,
      Intent.ACTION_TIME_CHANGED,
      Intent.ACTION_TIMEZONE_CHANGED,
      Intent.ACTION_CONFIGURATION_CHANGED -> {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(ComponentName(context, Clock2x2WidgetProvider::class.java))
        if (ids.isNotEmpty()) {
          renderWidgets(context, manager, ids)
        }
      }
    }
  }

  private fun renderWidgets(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views = RemoteViews(context.packageName, R.layout.clock_2x2_widget)
      val options = appWidgetManager.getAppWidgetOptions(widgetId)
      val (widthPx, heightPx) = resolveWidgetSizePx(context, options)
      val bitmap = drawDateCardBitmap(context, widthPx, heightPx)

      views.setOnClickPendingIntent(
          R.id.widget_canvas,
          HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
      )
      views.setImageViewBitmap(R.id.widget_canvas, bitmap)
      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  private fun drawDateCardBitmap(context: Context, widthPx: Int, heightPx: Int): Bitmap {
    val safeWidth = widthPx.coerceAtLeast(1)
    val safeHeight = heightPx.coerceAtLeast(1)

    val bitmap = Bitmap.createBitmap(safeWidth, safeHeight, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val palette = widgetPalette(context)
    val backgroundPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      color = palette.surfacePrimary
    }
    val radius = dpToPx(context, 28f).toFloat()
    canvas.drawRoundRect(0f, 0f, safeWidth.toFloat(), safeHeight.toFloat(), radius, radius, backgroundPaint)

    val typeface = ResourcesCompat.getFont(context, R.font.space_mono_regular) ?: Typeface.MONOSPACE
    val now = Calendar.getInstance().time
    val dayText = SimpleDateFormat("EEE", Locale.getDefault()).format(now)
    val monthText = SimpleDateFormat("MMM", Locale.getDefault()).format(now)
    val dateText = SimpleDateFormat("d", Locale.getDefault()).format(now)

    val minSide = min(safeWidth, safeHeight).toFloat() 
    val labelSizePx = (minSide * 0.20f).coerceIn(spToPx(context, 20f), spToPx(context, 28f))
    val dateSizePx = (minSide * 0.60f).coerceIn(spToPx(context, 72f), spToPx(context, 128f))
    val labelGap = minSide * 0.05f

    val dayPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      this.typeface = typeface
      textSize = labelSizePx
      color = palette.activeDay
    }
    val monthPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      this.typeface = typeface
      textSize = labelSizePx
      color = palette.textIconSecondary
    }
    val datePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      this.typeface = typeface
      textSize = dateSizePx
      color = palette.textIconPrimary
      textAlign = Paint.Align.CENTER
    }

    // Measure actual glyph bounds (no invisible font padding)
    val dayBounds   = android.graphics.Rect()
    val monthBounds = android.graphics.Rect()
    val dateBounds  = android.graphics.Rect()
    dayPaint.getTextBounds(dayText, 0, dayText.length, dayBounds)
    monthPaint.getTextBounds(monthText, 0, monthText.length, monthBounds)
    datePaint.getTextBounds(dateText, 0, dateText.length, dateBounds)

    val dayWidth   = dayPaint.measureText(dayText)
    val monthWidth = monthPaint.measureText(monthText)
    val topRowWidth = dayWidth + labelGap + monthWidth
    val topStartX   = (safeWidth - topRowWidth) / 2f

    // Visible glyph heights from getTextBounds (tight, no font leading)
    val topRowHeight  = maxOf(dayBounds.height(), monthBounds.height()).toFloat()
    val dateRowHeight = dateBounds.height().toFloat()

    // Gap between the two rows — 24px 
    val rowGapPx = dpToPx(context, 24f).toFloat()

    // Total block height → centre the whole block vertically in the card
    val blockHeight = topRowHeight + rowGapPx + dateRowHeight
    val blockTop    = (safeHeight - blockHeight) / 2f

    // Draw day/month row — baseline = blockTop + row height (bottom of glyph box)
    val topBaseline = blockTop + topRowHeight
    canvas.drawText(dayText,   topStartX,                       topBaseline, dayPaint)
    canvas.drawText(monthText, topStartX + dayWidth + labelGap, topBaseline, monthPaint)

    // Draw date number — baseline = blockTop + topRow + gap + dateHeight
    val dateBaseline = blockTop + topRowHeight + rowGapPx + dateRowHeight
    canvas.drawText(dateText, safeWidth / 2f, dateBaseline, datePaint)

    return bitmap
  }

  private fun resolveWidgetSizePx(context: Context, options: Bundle): Pair<Int, Int> {
    val minWidthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
    val minHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
    val maxWidthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH, 0)
    val maxHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0)
    val widthDp = if (minWidthDp > 0) minWidthDp else if (maxWidthDp > 0) maxWidthDp else 110
    val heightDp = if (maxHeightDp > 0) maxHeightDp else if (minHeightDp > 0) minHeightDp else 110
    val widthPx = dpToPx(context, widthDp.toFloat()).coerceAtLeast(dpToPx(context, 110f))
    val heightPx = dpToPx(context, heightDp.toFloat()).coerceAtLeast(dpToPx(context, 110f))
    return widthPx to heightPx
  }

  private fun dpToPx(context: Context, dp: Float): Int =
      TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.resources.displayMetrics).toInt()

  private fun spToPx(context: Context, sp: Float): Float =
      TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, sp, context.resources.displayMetrics)
}
