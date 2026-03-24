//
//  CyclePeriodType+Label.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//

extension CyclePeriodType{
    func label(plural: Bool = true) -> String {
        switch self {
        case .days:
            return "day" + (plural ? "s" : "")
        case .weeks:
            return "week" + (plural ? "s" : "")
        case .months:
            return "month" + (plural ? "s" : "")
        case .years:
            return "year" + (plural ? "s" : "")
        }
    }
}
