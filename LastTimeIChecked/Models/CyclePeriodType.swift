//
//  CyclePeriodType.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//

enum CyclePeriodType : Codable, Sendable, Identifiable, CaseIterable{
    case days
    case weeks
    case months
    case years
    
    var id: String { label() }
}
