//
//  PrimaryButtonStyle.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var height: CGFloat? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(height: height)
            .background(Color.primary)
            .cornerRadius(10)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
    
    static func primary(height: CGFloat) -> Self {
        PrimaryButtonStyle(height: height)
    }
}
