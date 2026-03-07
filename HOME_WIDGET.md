# Home Widget Customization Guide

This file shows exactly where to edit the home widget UI and text.

## 1) Widget Text/Data (shared from Flutter)

Edit:
- `lib/core/services/widget_service.dart`

What you can change:
- Date format (`dateText`)
- Days-left text (`daysLeftText`)
- Widget refresh behavior

Current key line:
- `daysLeftText = '$daysLeft days left';`

## 2) iOS Widget UI

Edit:
- `ios/MyHomeWidget/MyHomeWidget.swift`

Main constants to tweak:
- `dotDiameter` -> icon size
- `dotGap` -> spacing between icons (horizontal + vertical)
- `dotColumns`, `dotRows` -> grid density
- `colorPast`, `colorCurrent`, `colorFuture` -> icon colors
- `dotPaddingH`, `dotPaddingTop`, `dotPaddingBottom` -> widget inner spacing
- `textFontSize`, `textPaddingH`, `textPaddingBottom` -> bottom text style/spacing

## 3) Android Widget UI

Edit:
- `android/app/src/main/kotlin/com/example/oryzn/Year4x2WidgetProvider.kt`
- `android/app/src/main/res/layout/year_4x2_widget.xml`
- `android/app/src/main/res/xml/year_4x2_widget_info.xml`

Main constants in Kotlin file:
- `DOT_DIAMETER_DP` -> icon size
- `DOT_GAP_DP` -> spacing between icons (horizontal + vertical)
- `DOT_COLUMNS` -> grid density
- `COLOR_PAST`, `COLOR_CURRENT`, `COLOR_FUTURE` -> icon colors

Layout XML controls:
- Current Android widget is bitmap-drawn in provider code via `widget_canvas`
- Font, spacing, colors are controlled in Kotlin provider

## 4) In-App Year View (not home widget)

If you also want to change icon size/spacing in the app's Year screen:
- `lib/features/home/presentation/year_view.dart`

Edit:
- `crossAxisSpacing`, `mainAxisSpacing` -> gap
- `width`, `height` in `Image.asset(...)` -> icon size

## 5) Typical quick edits

- Bigger icons:
  - iOS: increase `dotDiameter`
  - Android: increase `DOT_DIAMETER_DP`

- More gap between icons:
  - iOS: increase `dotGap`
  - Android: increase `DOT_GAP_DP`

- Tighter grid:
  - Reduce `dotGap` / `DOT_GAP_DP`
  - Or increase `dotColumns` (and optionally `dotRows`)

## 6) Apply and verify

1. Run the app once so shared widget data is refreshed.
2. Rebuild/run iOS/Android widget target after native UI changes.
3. Remove and re-add widget on home screen if launcher cache keeps old view.

## 7) Add another Android widget size

Use this naming pattern to avoid conflicts:
- Provider class: `<type>_<size>_widget` -> Kotlin class like `Month2x2WidgetProvider`
- Layout: `res/layout/<type>_<size>_widget.xml`
- Widget config: `res/xml/<type>_<size>_widget_info.xml`

Then register a new `<receiver>` in `AndroidManifest.xml` for that provider + xml config.
