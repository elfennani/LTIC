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
    var period: Int
    var periodType: CyclePeriodType
    var startsAt: Date
    var repeated: Bool
    var repeatFromLastCompleted: Bool
    var createdAt: Date = Date()
    
    init(name: String, period: Int, periodType: CyclePeriodType, startsAt: Date, repeated: Bool, repeatFromLastCompleted: Bool) {
        self.id = UUID()
        self.name = name
        self.period = period
        self.periodType = periodType
        self.startsAt = startsAt
        self.repeated = repeated
        self.repeatFromLastCompleted = repeatFromLastCompleted
    }
}

enum CyclePeriodType : Codable, Sendable{
    case days
    case weeks
    case months
    case years
}

extension CyclePeriodType{
    func label() -> String {
        switch self {
        case .days:
            return "days"
        case .weeks:
            return "weeks"
        case .months:
            return "months"
        case .years:
            return "years"
        }
    }
}
