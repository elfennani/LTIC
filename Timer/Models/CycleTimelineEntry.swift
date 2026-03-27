//
//  CycleTimelineEntry.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//
import WidgetKit

struct CycleTimelineEntry: TimelineEntry {
    let date: Date
    let id: UUID
    let icon: String
    let percentage: Float
    let label: String
    let name: String
}
