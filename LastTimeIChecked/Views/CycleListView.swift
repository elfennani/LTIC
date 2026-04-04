//
//  CycleListScreen.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData

struct CycleListView: View {
  @Environment(\.modelContext) var context
  @Query(sort: \Cycle.createdAt) var cycles: [Cycle]
  @State var newCycleSheet: Bool = false
    
  var body: some View {
    ScrollView{
      LazyVGrid(
        columns: .init(repeating: .init(spacing: 16), count: 2),
        spacing: 16
      ){
        ForEach(cycles){ cycle in
          NavigationLink(value: cycle){
            WidgetPreviewView(size: nil){
              WidgetPicker(entry: cycle.toTimelineEntry())
                .padding()
                .shadow(radius: 16)
            }.aspectRatio(1, contentMode: .fill)
          }
        }
      }
      .padding(16)
    }
    .navigationTitle("My Cycles")
    .toolbar{
      ToolbarItem(placement: .topBarTrailing){
        Button("New",systemImage: "plus",  action: { newCycleSheet = true })
      }
    }
    .sheet(isPresented: $newCycleSheet){
      CreateCycleView()
    }
    .navigationDestination(for: Cycle.self){ cycle in
      EditCycleView(cycle: cycle)
    }
  }
}
