import SwiftUI
import WidgetKit

private let appGroupId = "group.homeScreenApp"

// MARK: - Colors (matches Android widgetPalette dark)
// Edit these to change dot colors
private let colorPast    = Color.white                                      // days passed
private let colorCurrent = Color(red: 1.0, green: 0.267, blue: 0.0)        // today #FF4400
private let colorFuture  = Color(red: 0.267, green: 0.267, blue: 0.267)    // future #444444
private let colorSecondary = Color(red: 0.455, green: 0.451, blue: 0.451)  // #747373

// MARK: - Year dot grid constants
// Edit these to change dot size and spacing for year widget
private let yearDotColumns = 36
private let yearDotRows    = 11
private let yearDotDiameter: CGFloat = 7    // dot diameter in points
private let yearDotGap: CGFloat      = 5    // gap between dots
private var yearDotCell: CGFloat { yearDotDiameter + yearDotGap }

// MARK: - Month dot grid constants
// Edit these to change dot size and spacing for month widget
private let monthDotColumns = 7             // one column per day of week
private let monthDotDiameter: CGFloat = 10  // dot diameter in points
private let monthDotGap: CGFloat      = 6   // gap between dots
private var monthDotCell: CGFloat { monthDotDiameter + monthDotGap }

// MARK: - Helpers

private func daysInYear(for date: Date) -> Int {
    let year = Calendar.current.component(.year, from: date)
    let isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    return isLeap ? 366 : 365
}

private func dayOfYear(for date: Date) -> Int {
    Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
}

private func nextMidnight(from date: Date) -> Date {
    let cal = Calendar.current
    return cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: date)) ?? date.addingTimeInterval(86400)
}

// MARK: - Timeline entry & provider

struct OryznEntry: TimelineEntry {
    let date: Date
    let dateText: String
    let daysLeftText: String
}

struct OryznProvider: TimelineProvider {
    func placeholder(in context: Context) -> OryznEntry {
        OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
    }

    func getSnapshot(in context: Context, completion: @escaping (OryznEntry) -> Void) {
        completion(buildEntry(at: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OryznEntry>) -> Void) {
        let now = Date()
        completion(Timeline(entries: [buildEntry(at: now)], policy: .after(nextMidnight(from: now))))
    }

    private func buildEntry(at date: Date) -> OryznEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let cal = Calendar.current
        let doy = cal.ordinality(of: .day, in: .year, for: date) ?? 1
        let daysLeft = max(daysInYear(for: date) - doy, 0)
        let fallbackDate = dateFormatter.string(from: date)
        return OryznEntry(
            date: date,
            dateText: defaults?.string(forKey: "widget_date_text") ?? fallbackDate,
            daysLeftText: defaults?.string(forKey: "widget_days_left_text") ?? "\(daysLeft) days left"
        )
    }

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateFormat = "EEEE, d MMMM yyyy"
        return f
    }()
}

// MARK: - Year dot grid view

struct YearDotGrid: View {
    let date: Date

    private var dayIndex: Int { dayOfYear(for: date) - 1 }  // 0-based
    private var totalDays: Int { daysInYear(for: date) }

    var body: some View {
        GeometryReader { proxy in
            let naturalW = yearDotCell * CGFloat(yearDotColumns)
            let naturalH = yearDotCell * CGFloat(yearDotRows)
            let scale    = min(proxy.size.width / naturalW, proxy.size.height / naturalH)
            let cell     = yearDotCell * scale
            let dotSize  = yearDotDiameter * scale
            let offsetX  = (proxy.size.width  - naturalW * scale) / 2
            let offsetY  = (proxy.size.height - naturalH * scale) / 2

            ZStack {
                ForEach(0..<(yearDotColumns * yearDotRows), id: \.self) { i in
                    if i < totalDays {
                        let row = i / yearDotColumns
                        let col = i % yearDotColumns
                        Circle()
                            .fill(i < dayIndex ? colorPast : (i == dayIndex ? colorCurrent : colorFuture))
                            .frame(width: dotSize, height: dotSize)
                            .position(
                                x: offsetX + cell * CGFloat(col) + cell / 2,
                                y: offsetY + cell * CGFloat(row) + cell / 2
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Month dot grid view

struct MonthDotGrid: View {
    let date: Date

    private var cal: Calendar { Calendar.current }

    // 0-based weekday offset for the 1st of the month (0 = Monday)
    private var firstWeekdayOffset: Int {
        var comps = cal.dateComponents([.year, .month], from: date)
        comps.day = 1
        let first = cal.date(from: comps)!
        let wd = cal.component(.weekday, from: first)  // 1=Sun..7=Sat
        return (wd + 5) % 7  // convert to 0=Mon
    }

    private var daysInMonth: Int {
        cal.range(of: .day, in: .month, for: date)?.count ?? 30
    }

    private var dayOfMonth: Int {
        cal.component(.day, from: date)
    }

    private var totalSlots: Int { firstWeekdayOffset + daysInMonth }
    private var dotRows: Int { (totalSlots + monthDotColumns - 1) / monthDotColumns }

    var body: some View {
        GeometryReader { proxy in
            let naturalW = monthDotCell * CGFloat(monthDotColumns)
            let naturalH = monthDotCell * CGFloat(dotRows)
            let scale    = min(proxy.size.width / naturalW, proxy.size.height / naturalH)
            let cell     = monthDotCell * scale
            let dotSize  = monthDotDiameter * scale
            let offsetX  = (proxy.size.width  - naturalW * scale) / 2
            let offsetY  = (proxy.size.height - naturalH * scale) / 2

            ZStack {
                ForEach(0..<(monthDotColumns * dotRows), id: \.self) { i in
                    let dayNum = i - firstWeekdayOffset + 1  // 1-based
                    if dayNum >= 1 && dayNum <= daysInMonth {
                        let row = i / monthDotColumns
                        let col = i % monthDotColumns
                        Circle()
                            .fill(dayNum < dayOfMonth ? colorPast : (dayNum == dayOfMonth ? colorCurrent : colorFuture))
                            .frame(width: dotSize, height: dotSize)
                            .position(
                                x: offsetX + cell * CGFloat(col) + cell / 2,
                                y: offsetY + cell * CGFloat(row) + cell / 2
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Year Widget View

struct YearWidgetView: View {
    var entry: OryznEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(spacing: 0) {
            YearDotGrid(date: entry.date)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 8)

            if family != .systemSmall {
                HStack(spacing: 12) {
                    Text(entry.dateText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(entry.daysLeftText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .font(.custom("Space Mono", size: 12))
                .foregroundStyle(Color.white.opacity(0.94))
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 0.11, green: 0.11, blue: 0.11)  // #1C1C1C — matches Android dark bg
        }
    }
}

// MARK: - Month Widget View

struct MonthWidgetView: View {
    var entry: OryznEntry
    @Environment(\.widgetFamily) var family

    private var monthName: String {
        let f = DateFormatter(); f.dateFormat = "MMM"
        return f.string(from: entry.date).uppercased()
    }

    private var yearString: String {
        let f = DateFormatter(); f.dateFormat = "yyyy"
        return f.string(from: entry.date)
    }

    private var daysLeftInMonth: Int {
        let cal = Calendar.current
        let total = cal.range(of: .day, in: .month, for: entry.date)?.count ?? 30
        let day = cal.component(.day, from: entry.date)
        return max(total - day, 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: month name + year
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(monthName)
                    .font(.custom("Space Mono", size: 14))
                    .foregroundStyle(Color.white)
                Text(yearString)
                    .font(.custom("Space Mono", size: 11))
                    .foregroundStyle(colorSecondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)

            // Dot grid fills remaining space
            MonthDotGrid(date: entry.date)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 14)
                .padding(.bottom, 8)

            if family != .systemSmall {
                HStack {
                    Text("\(daysLeftInMonth) days left")
                        .lineLimit(1)
                    Spacer()
                }
                .font(.custom("Space Mono", size: 11))
                .foregroundStyle(colorSecondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 0.11, green: 0.11, blue: 0.11)
        }
    }
}

// MARK: - Clock Widget View

struct ClockWidgetView: View {
    var entry: OryznEntry

    private var dayName: String {
        let f = DateFormatter(); f.dateFormat = "EEE"
        return f.string(from: entry.date).uppercased()
    }

    private var monthName: String {
        let f = DateFormatter(); f.dateFormat = "MMM"
        return f.string(from: entry.date).uppercased()
    }

    private var dateNum: String {
        let f = DateFormatter(); f.dateFormat = "d"
        return f.string(from: entry.date)
    }

    var body: some View {
        // Matches Android Clock2x2: centered column, 20pt gap between rows
        VStack(spacing: 20) {
            HStack(spacing: 6) {
                Text(dayName)
                    .font(.custom("Space Mono", size: 16))
                    .foregroundStyle(colorCurrent)
                Text(monthName)
                    .font(.custom("Space Mono", size: 16))
                    .foregroundStyle(colorSecondary)
            }
            Text(dateNum)
                .font(.custom("Space Mono", size: 44))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color(red: 0.11, green: 0.11, blue: 0.11)
        }
    }
}

// MARK: - Widget definitions

struct YearWidget: Widget {
    let kind = "YearWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OryznProvider()) { entry in
            YearWidgetView(entry: entry)
        }
        .configurationDisplayName("Year Progress")
        .description("Dots showing your progress through the year.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MonthWidget: Widget {
    let kind = "MonthWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OryznProvider()) { entry in
            MonthWidgetView(entry: entry)
        }
        .configurationDisplayName("Month Progress")
        .description("Dots showing your progress through the month.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClockWidget: Widget {
    let kind = "ClockWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OryznProvider()) { entry in
            ClockWidgetView(entry: entry)
        }
        .configurationDisplayName("Date")
        .description("Shows today's day and date.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Previews

#Preview("Year Small", as: .systemSmall) { YearWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sun, 8 Mar 2026", daysLeftText: "298 days left")
}

#Preview("Year Medium", as: .systemMedium) { YearWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
}

#Preview("Year Large", as: .systemLarge) { YearWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
}

#Preview("Month Small", as: .systemSmall) { MonthWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
}

#Preview("Month Medium", as: .systemMedium) { MonthWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
}

#Preview("Clock Small", as: .systemSmall) { ClockWidget() } timeline: {
    OryznEntry(date: Date(), dateText: "Sunday, 8 March 2026", daysLeftText: "298 days left")
}
