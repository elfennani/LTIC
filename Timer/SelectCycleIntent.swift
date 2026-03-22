//
//  Intent.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//
import AppIntents
import WidgetKit
import SwiftData

struct SelectCycleIntent : WidgetConfigurationIntent{
    static var title: LocalizedStringResource = "Select Cycle"
    static var description: IntentDescription? = "Select a cycle from the list to display the next check date"
    
    @Parameter(title: "Cycle")
    var cycle: CycleEntity?
    
    init(cycle: CycleEntity) {
        self.cycle = cycle
    }
    init() {
        
    }
}

struct CycleEntity: AppEntity {
    var id: UUID
    let cycle: Cycle
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Cycle"
    static var defaultQuery = CycleQuery()
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: "\(cycle.name) • \(cycle.period) \(cycle.periodType.label())")
    }
    
    init(cycle: Cycle){
        self.id = cycle.id
        self.cycle = cycle
    }
    
    static let examples: [CycleEntity] = [
        Cycle(
            name: "Morning Workout",
            period: 1,
            periodType: .days,
            startsAt: Date(),
            repeated: true,
            repeatFromLastCompleted: false
        ),
        Cycle(
            name: "Weekly Team Meeting",
            period: 1,
            periodType: .weeks,
            startsAt: Date(),
            repeated: true,
            repeatFromLastCompleted: true
        ),
        Cycle(
            name: "Monthly Report",
            period: 1,
            periodType: .months,
            startsAt: Date(),
            repeated: true,
            repeatFromLastCompleted: false
        )
    ].map({ CycleEntity(cycle: $0) })
}


struct CycleQuery: EntityQuery {
    func entities(for identifiers: [CycleEntity.ID]) async throws -> [CycleEntity] {
        let context = ModelContext(sharedModelContainer)
        let descriptor = FetchDescriptor<Cycle>(
            predicate: #Predicate { identifiers.contains($0.id) }
        )
        let cycles = try context.fetch(descriptor)
        print(cycles)
        return cycles.map({ CycleEntity(cycle: $0) })
    }
    
    func suggestedEntities() async throws -> [CycleEntity] {
        let context = ModelContext(sharedModelContainer)
        let descriptor = FetchDescriptor<Cycle>()
        let cycles = try context.fetch(descriptor)
        print(cycles)
        return cycles.map({ CycleEntity(cycle: $0) })
    }
}
