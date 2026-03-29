//
//  CycleWidget.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//

import SwiftUI

struct ArcShape: Shape {
    var angle: Angle = .degrees(180)
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY + (rect.size.width / 4))
        let path = Path { path in
            path.addRelativeArc(
                center: center,
                radius: rect.size.width / 2,
                startAngle: .degrees(-180),
                delta: angle,
            )
        }
        
        return path
    }
}

struct FlatArcWidget: View {
    var entry: CycleTimelineEntry
    
    var body: some View {
        VStack {
            Text(entry.name.isEmpty ? "--" : entry.name).font(.caption)
            let progress = entry.percentage
            
            ZStack(alignment: .bottom){
                ArcShape()
                    .stroke(
                        .primaryDark,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .animation(.easeInOut, value: progress)
                ArcShape(angle: .degrees(Double((180 * progress))))
                    .stroke(
                        Color.primary,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .animation(.easeInOut, value: progress)

                Image(systemName: entry.icon)
                    .imageScale(.large)
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(8)
            .padding(.horizontal, 8)
            Text("\(entry.label)").font(.caption2)
        }
    }
}

