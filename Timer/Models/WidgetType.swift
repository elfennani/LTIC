//
//  WidgetType.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 28/3/2026.
//

enum WidgetType: Codable, Sendable, Identifiable, CaseIterable{
    case flatarc
    case glowline
    
    var id: String {
        switch self {
        case .flatarc: return "flatarc"
        case .glowline: return "glowline"
        }
    }
}
