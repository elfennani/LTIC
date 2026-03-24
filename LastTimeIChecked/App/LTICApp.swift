//
//  LastTimeICheckedApp.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData

@main
struct LastTimeICheckedApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                CycleListView()
            }
            .tint(.primary)
        }
        .modelContainer(sharedModelContainer)
    }
}
