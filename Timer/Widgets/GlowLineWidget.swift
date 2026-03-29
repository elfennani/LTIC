//
//  GlowLineWidget.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 28/3/2026.
//

import SwiftUI

struct VerticalLine: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0,y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        return path
    }
}
struct CursorShape: Shape {
    var cornerRadius: CGFloat = 4 // Adjust this to change the "roundness"

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define the three main points of your triangle
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: rect.width, y: 0)
        let bottomTip = CGPoint(x: rect.midX, y: rect.height)
        
        // Start slightly away from the top-left to allow for rounding
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        
        // Top edge
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        
        // Top-right corner
        path.addQuadCurve(to: CGPoint(x: rect.width, y: cornerRadius),
                          control: topRight)
        
        // Right slope down to the tip
        // We stop slightly before the actual tip to round it
        path.addLine(to: CGPoint(x: rect.midX + cornerRadius, y: rect.height - cornerRadius))
        
        // Rounded bottom tip
        path.addQuadCurve(to: CGPoint(x: rect.midX - cornerRadius, y: rect.height - cornerRadius),
                          control: bottomTip)
        
        // Left slope back up
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // Top-left corner
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0),
                          control: topLeft)
        
        path.closeSubpath()
        
        return path
    }
}

struct GlowLineWidget: View {
    var entry: CycleTimelineEntry
    
    var body: some View {
        VStack{
            Spacer()
            GeometryReader{ geo in
                VStack{
                    Spacer()
                    ZStack(alignment: .bottomLeading){
                        VStack(spacing: 0){
                            LinearGradient(gradient: Gradient(colors: [.clear, Color.primary]), startPoint: .top, endPoint: .bottom)
                                .frame(height: 24)
                                .opacity(0.35)
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.primary)
                        }
                        
                        VerticalLine()
                            .stroke(
                                .white,
                                style: StrokeStyle(lineWidth: 1)
                            )
                            .frame(height: 42)
                            .offset(x: 0, y: -1)
                            .offset(x: CGFloat(geo.size.width) * CGFloat(entry.percentage), y: 0)
                        
                        
                        CursorShape(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: 12, height: 10)
                            .offset(x: -6, y: -45)
                            .offset(x: CGFloat(geo.size.width) * CGFloat(entry.percentage), y: 0)
                    }
                }.frame(maxHeight: .infinity)
            }
            
            Spacer()
                .frame(height: 16)
                
            HStack{
                Text(entry.name)
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 2)
            HStack{
                Spacer()
                Text(entry.label)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.primary)
            }
        }
    }
}
