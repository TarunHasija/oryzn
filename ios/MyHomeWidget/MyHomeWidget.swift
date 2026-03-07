import SwiftUI
import WidgetKit

private let widgetKind = "MyHomeWidget"
private let appGroupId = "group.homeScreenApp"

// MARK: - Customization knobs
// Dot colors for past/current/future day states.
private let colorPast    = Color.white                                    // days already passed
private let colorCurrent = Color(red: 1.0, green: 0.267, blue: 0.0)      // today  → #FF4400 (activeDay)
private let colorFuture  = Color(red: 0.267, green: 0.267, blue: 0.267)  // days to come → #444444 (surfaceTertiary dark)

// Grid dimensions. Keep rows * columns >= 366 for leap years.
private let dotColumns = 36
private let dotRows    = 11

// Dot diameter in points.
private let dotDiameter: CGFloat = 7       

// Gap between dots in points (applies to horizontal and vertical spacing).
private let dotGap: CGFloat = 5            

// Cell size = dotDiameter + dotGap  (computed automatically — do not edit)
private var dotCell: CGFloat { dotDiameter + dotGap }

// Internal spacing around grid and labels.
private let dotPaddingH:      CGFloat = 14   // horizontal padding around the dot grid
private let dotPaddingTop:    CGFloat = 14   // top padding above the dot grid
private let dotPaddingBottom: CGFloat = 8    // gap between dot grid and text row
private let textPaddingH:     CGFloat = 18   // horizontal padding around the text row
private let textPaddingBottom: CGFloat = 14  // bottom padding below the text row

// Bottom row label font size.
private let textFontSize: CGFloat = 14   // font size for date & days-left labels

struct OryznWidgetEntry: TimelineEntry {
    let date: Date
    let dateText: String
    let daysLeftText: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> OryznWidgetEntry {
        OryznWidgetEntry(
            date: Date(),
            dateText: "Sunday, 20 July 2025",
            daysLeftText: "115 days left"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (OryznWidgetEntry) -> Void) {
        completion(buildEntry(at: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OryznWidgetEntry>) -> Void) {
        let currentDate = Date()
        let entry = buildEntry(at: currentDate)
        let nextRefresh = nextMidnight(from: currentDate)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func buildEntry(at date: Date) -> OryznWidgetEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let fallbackDateText = Self.dateFormatter.string(from: date)
        let fallbackDaysLeftText = "\(daysLeftInYear(from: date)) days left"
        // Native fallback is used if Flutter has not pushed shared values yet.
        return OryznWidgetEntry(
            date: date,
            dateText: defaults?.string(forKey: "widget_date_text") ?? fallbackDateText,
            daysLeftText: defaults?.string(forKey: "widget_days_left_text") ?? fallbackDaysLeftText
        )
    }

    private func daysLeftInYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let daysInYear = calendar.range(of: .day, in: .year, for: date)?.count ?? 365
        // Excludes today from "days left".
        return max(daysInYear - dayOfYear, 0)
    }

    private func nextMidnight(from date: Date) -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date))
        return tomorrow ?? date.addingTimeInterval(24 * 60 * 60)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter
    }()
}

struct MyHomeWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .bottom) {
            // ── Background color ── edit Color(red:green:blue:) to change background
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.07, green: 0.07, blue: 0.08))  // #101012

            VStack(spacing: 0) {
                // Dot grid — expands to fill all remaining vertical space
                DotField(date: entry.date)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, dotPaddingH)
                    .padding(.top, dotPaddingTop)
                    .padding(.bottom, dotPaddingBottom)

                // Bottom text row: date label + days-left label
                HStack(spacing: 12) {
                    Text(entry.dateText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(entry.daysLeftText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                // ── Text font ── change textFontSize constant above, or swap font name here
                .font(.custom("Space Mono", size: textFontSize))
                .foregroundStyle(Color.white.opacity(0.94))
                .padding(.horizontal, textPaddingH)
                .padding(.bottom, textPaddingBottom)
            }
        }
        .containerBackground(.clear, for: .widget)
    }
}

struct DotField: View {
    let date: Date

    // Day-of-year index (1-based)
    private var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
    }

    // Total days in the current year (365 or 366)
    private var daysInYear: Int {
        let year = Calendar.current.component(.year, from: date)
        let isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
        return isLeap ? 366 : 365
    }

    var body: some View {
        GeometryReader { proxy in
            // Scale factor: fit the fixed-size grid into the available frame uniformly.
            // The grid's natural size is (dotCell × columns) wide × (dotCell × rows) tall.
            let naturalW = dotCell * CGFloat(dotColumns)
            let naturalH = dotCell * CGFloat(dotRows)
            let scale    = min(proxy.size.width / naturalW, proxy.size.height / naturalH)

            // Scaled cell and dot sizes — grow automatically when the widget is made larger.
            // To change dot size: edit dotDiameter above.
            // To change spacing: edit dotGap above.
            let cellScaled = dotCell     * scale
            let dotSize    = dotDiameter * scale

            // Offset to centre the grid inside the available space
            let offsetX = (proxy.size.width  - naturalW * scale) / 2
            let offsetY = (proxy.size.height - naturalH * scale) / 2

            let dayIndex = dayOfYear - 1  // convert to 0-based
            let totalDays = daysInYear    // 365 or 366 — only draw this many dots

            ZStack {
                ForEach(0..<(dotColumns * dotRows), id: \.self) { index in
                    // Skip slots beyond the last day of the year — leaves them invisible
                    if index < totalDays {
                    let row = index / dotColumns
                    let col = index % dotColumns
                    // Centre of this cell (grid offset + cell centre)
                    let cx = offsetX + cellScaled * CGFloat(col) + cellScaled / 2
                    let cy = offsetY + cellScaled * CGFloat(row) + cellScaled / 2

                    // ── Dot color per state ──
                    // Edit colorPast / colorCurrent / colorFuture constants at top of file.
                    let color: Color = {
                        if index < dayIndex  { return colorPast    }  // already passed
                        if index == dayIndex { return colorCurrent  }  // today
                        return colorFuture                             // still to come
                    }()

                    Circle()
                        .fill(color)
                        .frame(width: dotSize, height: dotSize)
                        .position(x: cx, y: cy)
                    } // end if index < totalDays
                }
            }
        }
    }
}

struct MyHomeWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: widgetKind, provider: Provider()) { entry in
            MyHomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Oryzn Time Left")
        .description("Shows today's date and how many days are left in this year.")
        .supportedFamilies([.systemMedium])
    }
}

struct MyHomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyHomeWidgetEntryView(
            entry: OryznWidgetEntry(
                date: Date(),
                dateText: "Sunday, 20 July 2025",
                daysLeftText: "115 days left"
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
