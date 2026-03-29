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
            icon: "leaf",
            percentage: 0.6,
            label: "In 2 days",
            name: "Watering plants",
            widget: .glowline
        )
    }
    
    func snapshot(for configuration: SelectCycleIntent, in context: Context) async -> CycleTimelineEntry {
        return CycleTimelineEntry(
            date: Date(),
            id: UUID(),
            icon: "leaf",
            percentage: 0.6,
            label: "In 2 days",
            name: "Watering plants",
            widget: .flatarc
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
            
            let percentage = Float(distance % cycle.periodInSeconds()) / Float(cycle.periodInSeconds())
            let durationTillNext = Int(ceil(Float(cycle.periodInSeconds()) * (1-percentage)))
            
            
            let entry = CycleTimelineEntry(
                date: date,
                id: entryDetails.id,
                icon: cycle.icon,
                percentage: percentage,
                label: "In less than \(durationTillNext / 86400) days",
                name: cycle.name,
                widget: cycle.widgetType
            )
            print("Entry Type: \(cycle.widgetType)")
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
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
                ZStack{
                    WidgetPicker(entry: entry)
                }
                    .containerBackground(.widgetBackground, for: .widget)
                    .foregroundColor(.widgetForeground)
                    .modelContainer(sharedModelContainer)
            } else {
                WidgetPicker(entry: entry)
                    .padding()
                    .background(.widgetBackground)
                    .foregroundStyle(.widgetForeground)
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
        icon: "leaf",
        percentage: 0.25,
        label: "In 3 days",
        name: "Workout",
        widget: .flatarc
    )

    CycleTimelineEntry(
        date: Date().addingTimeInterval(3600), // +1 hour
        id: UUID(),
        icon: "leaf",
        percentage: 0.75,
        label: "In 6 hours",
        name: "Study Session",
        widget: .glowline
    )
}
