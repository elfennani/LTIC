//
//  Timer.swift
//  Timer
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CycleTimelineEntry {
        return CycleTimelineEntry(
            date: Date(),
            id: UUID(),
            percentage: 0.6,
            label: "In 2 days",
            name: "Watering plants"
        )
    }
    
    func snapshot(for configuration: SelectCycleIntent, in context: Context) async -> CycleTimelineEntry {
        return CycleTimelineEntry(
            date: Date(),
            id: UUID(),
            percentage: 0.6,
            label: "In 2 days",
            name: "Watering plants"
        )
    }
    
    func timeline(for configuration: SelectCycleIntent ,in context: Context) async -> Timeline<CycleTimelineEntry> {
        guard let entryDetails = configuration.cycle else { return Timeline(entries: [], policy: .atEnd) }
        var entries: [CycleTimelineEntry] = []
        
        for hour in 0..<24 {
            let calendar = Calendar.current
            let cycle = entryDetails.cycle
            
            let from = calendar.startOfDay(for: cycle.startsAt)
            let date = calendar.date(byAdding: .hour, value: hour, to: Date())!
            
            let distance = calendar.dateComponents([.second], from: from, to: date).second!
            print("Start: \(from)")
            print("End: \(date)")
            let durationTillNext = distance % cycle.periodInSeconds()
            let percentage = Float(durationTillNext) / Float(cycle.periodInSeconds())
            
            let entry = CycleTimelineEntry(
                date: date,
                id: entryDetails.id,
                percentage: percentage,
                label: "In \(distance / 86400) days",
                name: cycle.name
            )
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }
}

struct CycleTimelineEntry: TimelineEntry {
    let date: Date
    let id: UUID
    let percentage: Float
    let label: String
    let name: String
}

struct TimerEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.name).font(.caption)
            
            ZStack(alignment: .bottom){
                Canvas{ context, size in
                    let radius = min(size.width, size.height) - 16
                    let lineWidth = 16
                    
                    let arcBackgroundPath = Path{ path in
                        path.addRelativeArc(
                            center: .init(x: size.width / 2, y: size.height),
                            radius: radius,
                            startAngle: .degrees(-180),
                            delta: .degrees(180),
                        )
                    }
                    var arcValuePath = Path()
                    
                    arcValuePath.addRelativeArc(
                        center: .init(x: size.width / 2, y: size.height),
                        radius: radius,
                        startAngle: .degrees(-180),
                        delta: .degrees(Double((180 * entry.percentage))),
                    )
                    
                    context.stroke(
                        arcBackgroundPath,
                        with: .color(.gray.opacity(0.5)),
                        lineWidth: 16,
                    )
                    
                    context.stroke(
                        arcValuePath,
                        with: .color(.primary),
                        lineWidth: 16
                    )
                    
                    let arrow = Path { path in
                        path.move(to: .init(x: CGFloat(lineWidth - 4), y: size.height))
                        path.addLine(to: .init(x: CGFloat(lineWidth - 4 + 8), y: size.height - 5))
                        path.addLine(to: .init(x: CGFloat(lineWidth - 4 + 8), y: size.height + 5))
                        path.closeSubpath()
                    }
                    
                    let center = CGPoint(x: size.width / 2, y: size.height)
                    context.translateBy(x: center.x, y: center.y)
                    context.rotate(by: .degrees(Double((180 * entry.percentage))))
                    context.translateBy(x: -center.x, y: -center.y)
                    
                    context.fill(arrow, with: .color(.primary))
                }
                Text(entry.percentage.formatted(.percent.precision(.fractionLength(0))))
                    .font(.title2)
            }.padding(8)
            Text("\(entry.label)").font(.caption2)
        }
    }
}

struct Timer: Widget {
    let kind: String = "LTIC Timer"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectCycleIntent.self,
            provider: Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                TimerEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .modelContainer(sharedModelContainer)
            } else {
                TimerEntryView(entry: entry)
                    .padding()
                    .background()
                    .modelContainer(sharedModelContainer)
            }
        }
        .configurationDisplayName("Task Checkup Timer")
        .description("Shows how much left until you check your task again.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    Timer()
} timeline: {
    CycleTimelineEntry(
        date: Date(),
        id: UUID(),
        percentage: 0.25,
        label: "In 3 days",
        name: "Workout"
    )

    CycleTimelineEntry(
        date: Date().addingTimeInterval(3600), // +1 hour
        id: UUID(),
        percentage: 0.75,
        label: "In 6 hours",
        name: "Study Session"
    )
}
