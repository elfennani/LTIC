//
//  Cycle.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftData
import Foundation

@Model
class Cycle: @unchecked Sendable{
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var period: Int
    var periodType: CyclePeriodType
    var startsAt: Date
    var repeated: Bool
    var repeatFromLastCompleted: Bool
    var createdAt: Date = Date()
    var widgetType: WidgetType = WidgetType.flatarc
    
    init(name: String, icon: String, period: Int, periodType: CyclePeriodType, startsAt: Date, repeated: Bool, repeatFromLastCompleted: Bool, widgetType: WidgetType = .flatarc) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.period = period
        self.periodType = periodType
        self.startsAt = startsAt
        self.repeated = repeated
        self.repeatFromLastCompleted = repeatFromLastCompleted
        self.widgetType = widgetType
    }
}

