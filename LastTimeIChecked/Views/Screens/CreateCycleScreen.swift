//
//  CreateCycleScreen.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(height: 36)
            .background(Color.primary)
            .cornerRadius(10)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1.0) // whole button fades
    }
}

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal)
            .frame(height: 36)
            .background(.surface)
            .foregroundStyle(Color.foreground)
            .cornerRadius(10)    }
}


struct CreateCycleScreen: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var sheetOpen: Bool
    
    @State var duration: Int = 1
    @State var type: CyclePeriodType = CyclePeriodType.days
    @State var startsAt: Date = Date()
    @State var repeats: Bool = true
    @State var repeatFromLastCompleted = true
    @State var name: String = ""
    @State var showDatePicker = false
    
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
        VStack(alignment:.leading, spacing: 16){
            Text("Due every")
                .font(.callout.bold())
            HStack(spacing: 8){
                TextField("Duration", value: $duration, format: .number)
                    .textFieldStyle(AppTextFieldStyle())
                    .frame(width: 90)
                    .keyboardType(.numberPad)
                    .contentShape(Rectangle())

                    
                SelectionView{
                    let options: [CyclePeriodType] = [
                        .days,
                        .weeks,
                        .months,
                        .years
                    ]
                    ForEach(options){ cycleType in
                        SelectionOption(
                            action: { type = cycleType },
                            label: cycleType.label(plural: false).uppercased(),
                            active: type == cycleType
                        )
                    }
                }
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                        
            }
            .tint(.surfaceForeground)
            Divider()
                
            Text("Starts")
                .font(.callout.bold())
                
            HStack(alignment: .center){
                Button(action: { showDatePicker = true }){
                    Text(
                        startsAt
                            .formatted(.dateTime.day().month(.twoDigits).year())
                    )
                    .lineLimit(1)
                    .fontDesign(.monospaced)
                }
                .font(.system(size: 14, weight: .bold))
                .keyboardType(.numberPad)
                .padding(.horizontal)
                .frame(height: 36)
                .background(.surface)
                .foregroundStyle(Color.foreground)
                .cornerRadius(10)
                .sheet(isPresented: $showDatePicker){
                    DatePicker(
                        "In",
                        selection: $startsAt,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                }
                Button(action: { startsAt = Date() }){
                    Text("NOW")
                        .lineLimit(1)
                        .font(.system(size: 14, weight: .bold))
                            
                }
                .buttonStyle(PressableButtonStyle())
                    
                    
                Spacer()
                    
                Text("repeats")
                    .font(.callout.bold())
                Toggle("Repeats", isOn: $repeats)
                    .labelsHidden()
            }
                
            Divider()
                
            Text("Customize")
                .font(.callout.bold())
                
            TextField("Name", text: $name)
                .textFieldStyle(AppTextFieldStyle())
                
            Divider()
            Button(action: { save() }){
                Text("Create".uppercased())
                    .padding(.vertical, 8)
                    .frame(width: 270)
            }
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .buttonStyle(.glassProminent)
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
                
                
            Spacer()
            //                Form {
            //                    Section{
            //                        TextField("Name", text: $name)
            //                    }
            //                    Section("Due every"){
            //                        TextField("Duration", value: $duration, format: .number)
            //                            .keyboardType(.numberPad)
            //                        Picker("Type", selection: $type){
            //                            Text("Days").tag(CyclePeriodType.days)
            //                            Text("Weeks").tag(CyclePeriodType.weeks)
            //                            Text("Months").tag(CyclePeriodType.months)
            //                            Text("Years").tag(CyclePeriodType.years)
            //                        }
            //                    }
            //                    
            //                    Section("Starts"){
            //                        DatePicker("In", selection: $startsAt, displayedComponents: .date)
            //                        Toggle("Repeats", isOn: $repeats)
            //                    }
            //                    
            //                    if(repeats){
            //                        Section("Repeat"){
            //                            Picker("Repeat from", selection: $repeatFromLastCompleted){
            //                                Text("Last Completion").tag(true)
            //                                Text("Fixed Interval (\(duration) \(type.label()))")
            //                                    .tag(false)
            //                            }
            //                        }
            //                    }
            //                }
            //                Spacer()
        }
        .padding()
        .padding(.top, 32)
        .background(Color(UIColor.white))
    }
    
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var sheetOpen = true
    
    var body: some View {
        CreateCycleScreen(sheetOpen: $sheetOpen)
            .modelContainer(for: Cycle.self, inMemory: true)
            .tint(.primary)
            .foregroundStyle(Color.foreground)
    }
}
