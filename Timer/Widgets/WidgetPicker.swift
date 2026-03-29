//
//  WidgetPicker.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 28/3/2026.
//
import SwiftUI


struct WidgetPicker: View {
    let entry: CycleTimelineEntry
    
    var body: some View{
        switch entry.widget {
        case .flatarc:
            FlatArcWidget(entry: entry)
        case .glowline:
            GlowLineWidget(entry: entry)
        }
    }
}
