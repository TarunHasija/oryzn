package com.oryzn.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Bundle
import androidx.core.content.res.ResourcesCompat
import android.util.TypedValue
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import kotlin.math.ceil
import kotlin.math.roundToInt
import kotlin.math.sqrt


// Corner radius of the widget card in dp
private const val CARD_CORNER_DP = 24f

// Padding inside the card in dp  ← change this value to adjust inner spacing
private const val CARD_PADDING_DP = 16f

// Dot grid columns
private const val DOT_COLUMNS = 30
private const val MIN_DOT_COLUMNS = 20

// Dot diameter in dp  ← change this to make dots bigger / smaller
private const val DOT_DIAMETER_DP = 10f

// Gap between dots in dp  ← change this to adjust spacing between dots
private const val DOT_GAP_DP = 4f

// Text size in sp for the date and days-left labels  ← change font size here
private const val TEXT_SIZE_SP = 10f

// Gap between dot grid and text row in dp
private const val TEXT_TOP_GAP_DP = 8f
private const val TEXT_LINE_GAP_DP = 2f

class Year2x2WidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views = RemoteViews(context.packageName, R.layout.year_2x2_widget)

      views.setOnClickPendingIntent(
          R.id.widget_canvas,
          HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
      )

      val fallbackDateText = formatDate()
      val fallbackDaysLeftText = "${daysLeftInYear()} days left"
      val dateText = widgetData.getString(KEY_DATE_TEXT, fallbackDateText) ?: fallbackDateText
      val daysLeftText = widgetData.getString(KEY_DAYS_LEFT_TEXT, fallbackDaysLeftText) ?: fallbackDaysLeftText

      val options = appWidgetManager.getAppWidgetOptions(widgetId)
      val (widthPx, heightPx) = resolveWidgetSizePx(context, options)

      val bitmap = drawWidgetBitmap(context, widthPx, heightPx, dateText, daysLeftText)
      views.setImageViewBitmap(R.id.widget_canvas, bitmap)

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  override fun onReceive(context: Context, intent: android.content.Intent) {
    super.onReceive(context, intent)
    if (intent.action == android.content.Intent.ACTION_CONFIGURATION_CHANGED) {
      val manager = AppWidgetManager.getInstance(context)
      val ids = manager.getAppWidgetIds(android.content.ComponentName(context, Year2x2WidgetProvider::class.java))
      if (ids.isNotEmpty()) onUpdate(context, manager, ids, HomeWidgetPlugin.getData(context))
    }
  }

  override fun onAppWidgetOptionsChanged(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetId: Int,
      newOptions: Bundle,
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    onUpdate(context, appWidgetManager, intArrayOf(appWidgetId), HomeWidgetPlugin.getData(context))
  }

  private fun drawWidgetBitmap(
      context: Context,
      widthPx: Int,
      heightPx: Int,
      dateText: String,
      daysLeftText: String,
  ): Bitmap {
    val bitmap = Bitmap.createBitmap(widthPx, heightPx, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val pad    = dpToPx(context, CARD_PADDING_DP).toFloat()
    val corner = dpToPx(context, CARD_CORNER_DP).toFloat()
    val palette = widgetPalette(context)

    // ── Background card ──
    val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      color = palette.surfacePrimary
    }
    canvas.drawRoundRect(0f, 0f, widthPx.toFloat(), heightPx.toFloat(), corner, corner, bgPaint)

    // ── Text (Space Mono) ──
    // Load from res/font — accessible to the widget process unlike flutter_assets
    val typeface = ResourcesCompat.getFont(context, R.font.space_mono_regular)
        ?: Typeface.MONOSPACE
    val textPx = spToPx(context, TEXT_SIZE_SP)
    val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      color = palette.textIconPrimary
      this.typeface = typeface
      textSize = textPx
    }

    // Measure text row height (ascent + descent)
    val fm = textPaint.fontMetrics
    val textRowH = fm.descent - fm.ascent
    val textTopGap = dpToPx(context, TEXT_TOP_GAP_DP).toFloat()
    val lineGap = dpToPx(context, TEXT_LINE_GAP_DP).toFloat()

    // 2x2 can be too narrow for one-line "date + days-left". Fall back to 2 centered lines.
    val shortDateText = SimpleDateFormat("d MMM yyyy", Locale.getDefault()).format(Calendar.getInstance().time)
    val dateInlineWidth = textPaint.measureText(dateText)
    val daysWidth = textPaint.measureText(daysLeftText)
    val availableTextW = widthPx - (2f * pad)
    val canRenderInline = (dateInlineWidth + daysWidth + pad) <= availableTextW

    val textBlockH = if (canRenderInline) textRowH else (textRowH * 2f + lineGap)
    val baselineBottom = heightPx - pad - fm.descent

    if (canRenderInline) {
      // Date on the left and days-left on the right.
      canvas.drawText(dateText, pad, baselineBottom, textPaint)
      canvas.drawText(daysLeftText, widthPx - pad - daysWidth, baselineBottom, textPaint)
    } else {
      // Two-line centered fallback for narrow widgets.
      val topLineWidth = textPaint.measureText(shortDateText)
      val topBaseline = baselineBottom - textRowH - lineGap
      canvas.drawText(shortDateText, (widthPx - topLineWidth) / 2f, topBaseline, textPaint)
      canvas.drawText(daysLeftText, (widthPx - daysWidth) / 2f, baselineBottom, textPaint)
    }

    // ── Dot grid ──
    val gridTop    = pad
    val gridBottom = heightPx - pad - textBlockH - textTopGap
    val gridLeft   = pad
    val gridRight  = widthPx - pad
    val gridW      = gridRight - gridLeft
    val gridH      = (gridBottom - gridTop).coerceAtLeast(1f)

    val daysInYear = Calendar.getInstance().getActualMaximum(Calendar.DAY_OF_YEAR)
    val dayIndex   = Calendar.getInstance().get(Calendar.DAY_OF_YEAR) - 1  // 0-based

    // Pick column count that best fills the available grid area with square cells.
    val aspect = gridW / gridH
    val approxColumns = sqrt(daysInYear * aspect).roundToInt()
    val start = (approxColumns - 4).coerceAtLeast(MIN_DOT_COLUMNS)
    val end = (approxColumns + 4).coerceAtMost(DOT_COLUMNS)

    var columns = approxColumns.coerceIn(MIN_DOT_COLUMNS, DOT_COLUMNS)
    var rows = ceil(daysInYear.toDouble() / columns).toInt().coerceAtLeast(1)
    var bestCell = minOf(gridW / columns, gridH / rows)
    var bestFillArea = (bestCell * columns) * (bestCell * rows)

    for (candidate in start..end) {
      val candidateRows = ceil(daysInYear.toDouble() / candidate).toInt().coerceAtLeast(1)
      val candidateCell = minOf(gridW / candidate, gridH / candidateRows)
      val candidateFillArea = (candidateCell * candidate) * (candidateCell * candidateRows)
      if (candidateFillArea > bestFillArea) {
        bestFillArea = candidateFillArea
        bestCell = candidateCell
        columns = candidate
        rows = candidateRows
      }
    }

    val cell = bestCell
    val gridUsedW = cell * columns
    val gridUsedH = cell * rows
    val offsetX = gridLeft + (gridW - gridUsedW) / 2f
    val offsetY = gridTop + (gridH - gridUsedH) / 2f
    // Fixed size ratio from DOT_DIAMETER_DP and DOT_GAP_DP.
    val fillRatio = DOT_DIAMETER_DP / (DOT_DIAMETER_DP + DOT_GAP_DP)
    val radius = (cell * fillRatio / 2f)
        .coerceAtLeast(2f)
        .coerceAtMost(cell / 2f)

    val dotPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply { style = Paint.Style.FILL }

    for (index in 0 until columns * rows) {
      if (index >= daysInYear) break
      val row = index / columns
      val col = index % columns
      val cx  = offsetX + cell * col + cell / 2f
      val cy  = offsetY + cell * row + cell / 2f

      dotPaint.color = when {
        index < dayIndex  -> palette.textIconPrimary
        index == dayIndex -> palette.activeDay
        else              -> palette.surfaceTertiary
      }
      canvas.drawCircle(cx, cy, radius, dotPaint)
    }

    return bitmap
  }

  private fun resolveWidgetSizePx(context: Context, options: Bundle): Pair<Int, Int> {
    val minWidthDp  = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH,  0)
    val minHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
    val maxWidthDp  = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH,  0)
    val maxHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0)
    val widthDp  = if (minWidthDp  > 0) minWidthDp  else if (maxWidthDp  > 0) maxWidthDp  else 280
    val heightDp = if (maxHeightDp > 0) maxHeightDp else if (minHeightDp > 0) minHeightDp else 120
    val widthPx  = dpToPx(context, widthDp.toFloat()).coerceAtLeast(dpToPx(context, 120f))
    val heightPx = dpToPx(context, heightDp.toFloat()).coerceAtLeast(dpToPx(context, 80f))
    return widthPx to heightPx
  }

  private fun formatDate(): String =
      SimpleDateFormat("EEEE, d MMMM yyyy", Locale.getDefault()).format(Calendar.getInstance().time)

  private fun daysLeftInYear(): Int {
    val today = Calendar.getInstance()
    return (today.getActualMaximum(Calendar.DAY_OF_YEAR) - today.get(Calendar.DAY_OF_YEAR)).coerceAtLeast(0)
  }

  private fun dpToPx(context: Context, dp: Float): Int =
      TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.resources.displayMetrics).toInt()

  private fun spToPx(context: Context, sp: Float): Float =
      TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, sp, context.resources.displayMetrics)

  companion object {
    private const val KEY_DATE_TEXT      = "widget_date_text"
    private const val KEY_DAYS_LEFT_TEXT = "widget_days_left_text"
  }
}
