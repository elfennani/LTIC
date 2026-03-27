//
//  WidgetPreviewView.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 24/3/2026.
//

import SwiftUI
import WidgetKit

struct PredefinedWidgetSize{
    let width: CGFloat
    let height: CGFloat
    let widgetSize: CGFloat
}

struct WidgetPreviewView<Content: View>: View {
    let content : () -> Content
    
    /// A predefined list of the small variant widget in various iPhone screen sizes
    private var sizes: [PredefinedWidgetSize] = [
        PredefinedWidgetSize(width:430,height:932, widgetSize:170),
        PredefinedWidgetSize(width:428,height:926, widgetSize:170),
        PredefinedWidgetSize(width:414,height:896, widgetSize:169),
        PredefinedWidgetSize(width:414,height:736, widgetSize:159),
        PredefinedWidgetSize(width:393,height:852, widgetSize:158),
        PredefinedWidgetSize(width:390,height:844, widgetSize:158),
        PredefinedWidgetSize(width:375,height:812, widgetSize:155),
        PredefinedWidgetSize(width:375,height:667, widgetSize:148),
        PredefinedWidgetSize(width:360,height:780, widgetSize:155),
        PredefinedWidgetSize(width:320,height:568, widgetSize:141)
    ]
    
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        let width = UIScreen.main.bounds.width
        let size = sizes.min(by: { abs($0.width - width) < abs($1.width - width) })?.widgetSize ?? 0
        
        
        HStack(content: content)
        .frame(width: size, height: size)
        .background(.widgetBackground)
        .foregroundStyle(.widgetForeground)
        .cornerRadius(22)
    }
    
    func closestWidgetSize(for width: CGFloat) -> CGSize {
        // Define standard widget sizes (iPhone example, in points)
        let widgetSizes: [WidgetFamily: CGSize] = [
            .systemSmall: CGSize(width: 155, height: 155),
            .systemMedium: CGSize(width: 329, height: 155),
            .systemLarge: CGSize(width: 329, height: 345),
            .systemExtraLarge: CGSize(width: 716, height: 345) // iPad
        ]
        
        // Find the closest width
        let closest = widgetSizes.min { abs($0.value.width - width) < abs($1.value.width - width) }
        return closest?.value ?? CGSize(width: width, height: width) // fallback
    }

}
