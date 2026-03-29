//
//  ButtonStyle+Secondary.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//
import SwiftUI


struct SecondaryButtonStyle: ButtonStyle {
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background(.surface)
            .foregroundStyle(Color.foreground)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: Self {
        SecondaryButtonStyle()
    }
    
    static func secondary(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        SecondaryButtonStyle(width: width, height: height)
    } 
}
