//
//  Cycle+TimelineEntryMap.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 29/3/2026.
//

import Foundation

extension Cycle{
  func toTimelineEntry(date: Date = Date()) -> CycleTimelineEntry{
    let calendar = Calendar.current
    let from = calendar.startOfDay(for: self.startsAt)
    
    let distance = calendar.dateComponents([.second], from: from, to: date).second!
    
    let percentage = Float(distance % self.periodInSeconds()) / Float(self.periodInSeconds())
    let durationTillNext = Int(ceil(Float(self.periodInSeconds()) * (1-percentage)))
    
    return CycleTimelineEntry(
      date: date,
      id: self.id,
      icon: self.icon,
      percentage: percentage,
      label: "In less than \(durationTillNext / 86400) days",
      name: self.name,
      widget: self.widgetType
    )
  }
}
