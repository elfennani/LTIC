//
//  Container.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 22/3/2026.
//
import SwiftData
import Foundation

public var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Cycle.self
    ])
    
    let configuration = ModelConfiguration(groupContainer: .identifier("group.com.elfen.LastIChecked"))

    do {
        return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
