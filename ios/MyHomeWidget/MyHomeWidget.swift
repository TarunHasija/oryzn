import SwiftUI
import WidgetKit

private let widgetKind = "MyHomeWidget"
private let appGroupId = "group.homeScreenApp"

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

        return OryznWidgetEntry(
            date: date,
            dateText: defaults?.string(forKey: "widget_date_text") ?? fallbackDateText,
            daysLeftText: defaults?.string(forKey: "widget_days_left_text") ?? fallbackDaysLeftText
        )
    }

    private func daysLeftInYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: date)
        let startOfNextYear = calendar.date(
            from: DateComponents(year: calendar.component(.year, from: date) + 1, month: 1, day: 1)
        )!
        return calendar.dateComponents([.day], from: startOfToday, to: startOfNextYear).day ?? 0
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
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.11, green: 0.11, blue: 0.12),
                            Color(red: 0.07, green: 0.07, blue: 0.08),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(spacing: 0) {
                DotField()
                    .frame(maxWidth: .infinity)
                    .frame(height: 82)
                    .padding(.horizontal, 12)
                    .padding(.top, 14)

                Spacer(minLength: 0)

                HStack(spacing: 12) {
                    Text(entry.dateText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(entry.daysLeftText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .foregroundStyle(Color.white.opacity(0.94))
                .padding(.horizontal, 18)
                .padding(.bottom, 16)
            }
        }
        .containerBackground(.clear, for: .widget)
    }
}

struct DotField: View {
    private let rows = 9
    private let columns = 34

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let stepX = width / CGFloat(columns + 1)
            let stepY = height / CGFloat(rows + 1)
            let dotSize = max(CGFloat(3), min(stepX, stepY) * 0.56)

            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        Circle()
                            .fill(Color.white.opacity(dotOpacity(for: row)))
                            .frame(width: dotSize, height: dotSize)
                            .position(
                                x: stepX * CGFloat(column + 1) + (row.isMultiple(of: 2) ? .zero : stepX * 0.5),
                                y: stepY * CGFloat(row + 1)
                            )
                    }
                }

                LinearGradient(
                    colors: [
                        .clear,
                        Color.black.opacity(0.78),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }

    private func dotOpacity(for row: Int) -> Double {
        let progress = Double(row) / Double(max(rows - 1, 1))
        return max(0.14, 1.0 - (progress * 0.82))
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
