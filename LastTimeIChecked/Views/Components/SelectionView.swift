//
//  Selection.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 23/3/2026.
//
import SwiftUI
import Swift

struct SelectionView<Content: View>: View {
    let content: () -> Content
    
    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    var body: some View {
        HStack(content: content)
        .padding(2)
        .background(.surface)
        .cornerRadius(12)
    }
}

struct SelectionOption : View{
    let action: () -> Void
    let label: String
    let active: Bool
    
    var body: some View{
        Button(action: { action() }){
            HStack(alignment: .top, spacing: 0){
                Text(label)
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .bold))
                Text("s")
                    .font(.system(size: 10, weight: .bold))
                    .offset(x: 0, y: -1)
            }.frame(maxWidth:.infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 8)
        .background(active ? .white : .clear)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 2)
    }
}
