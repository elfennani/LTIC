//
//  EditCycleView.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 4/4/2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct EditCycleView : View {
  let cycle: Cycle
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    let widgetCenter = WidgetCenter.shared
    ScrollView(.vertical){
      CreateCycleView(
        cycle: cycle,
      )
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Edit Cycle")
      .toolbar{
        ToolbarItem(placement: .topBarTrailing){
          Button("Delete", systemImage: "trash", action: {
            widgetCenter.reloadAllTimelines()
            context.delete(cycle)
            dismiss()
          })
        }
      }
  }
}
