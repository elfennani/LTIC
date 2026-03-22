//
//  Cycle+PeriodInDays.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 22/3/2026.
//

extension Cycle{
    func periodInSeconds()->Int{
        switch self.periodType {
        case .days:
            let days = self.period
            return days * 86400
        case .weeks:
            let days = self.period * 7
            return days * 86400
        case .months:
            let days = self.period * 30
            return days * 86400
        case .years:
            let days = self.period * 365
            return days * 86400
        }
    }
}
