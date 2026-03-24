//
//  CycleListScreen.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData

struct CycleListView: View {
    @Query(sort: \Cycle.createdAt) var cycles: [Cycle]
    @State var newCycleSheet: Bool = false
    
    var body: some View {
        List(cycles){ cycle in
            NavigationLink(value: cycle){
                Text(cycle.name)
            }
        }
        .navigationTitle("My Cycles")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("New",systemImage: "plus",  action: { newCycleSheet = true })
            }
        }
        .sheet(isPresented: $newCycleSheet){
            CreateCycleView(
                sheetOpen: $newCycleSheet
            )
        }
        .navigationDestination(for: Cycle.self){ cycle in
            CycleDetailView(cycle: cycle)
        }
    }
}
