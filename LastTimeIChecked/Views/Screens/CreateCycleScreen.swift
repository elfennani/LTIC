//
//  CreateCycleScreen.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData

struct CreateCycleScreen: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var sheetOpen: Bool
    
    @State var duration: Int = 1
    @State var type: CyclePeriodType = CyclePeriodType.days
    @State var startsAt: Date = Date()
    @State var repeats: Bool = true
    @State var repeatFromLastCompleted = true
    @State var name: String = ""
    
    @State var error: String?
    
    @MainActor
    func save() {
        if(name.isEmpty){
            error = "Please enter a name"
            return;
        } else if(duration <= 1){
            error = "Please enter a valid duration (more than 1)"
            return;
        }
        
        error = nil
        
        let cycle = Cycle(
            name: name,
            period: duration,
            periodType: type,
            startsAt: startsAt,
            repeated: repeats,
            repeatFromLastCompleted: repeatFromLastCompleted
        )
        
        modelContext.insert(cycle)
        do{
            try modelContext.save()
        }catch {
            self.error = "Failed to save cycle"
            return;
        }
        
        error = nil
        sheetOpen.toggle()
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Form {
                    Section{
                        TextField("Name", text: $name)
                    }
                    Section("Due every"){
                        TextField("Duration", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                        Picker("Type", selection: $type){
                            Text("Days").tag(CyclePeriodType.days)
                            Text("Weeks").tag(CyclePeriodType.weeks)
                            Text("Months").tag(CyclePeriodType.months)
                            Text("Years").tag(CyclePeriodType.years)
                        }
                    }
                    
                    Section("Starts"){
                        DatePicker("In", selection: $startsAt, displayedComponents: .date)
                        Toggle("Repeats", isOn: $repeats)
                    }
                    
                    if(repeats){
                        Section("Repeat"){
                            Picker("Repeat from", selection: $repeatFromLastCompleted){
                                Text("Last Completion").tag(true)
                                Text("Fixed Interval (\(duration) \(type.label()))")
                                    .tag(false)
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Create Cycle")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: { save() }){
                        Text("Save")
                    }.buttonStyle(.glassProminent)
                }
            }
        }
    }
}
