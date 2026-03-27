//
//  CreateCycleScreen.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//

import SwiftUI
import SwiftData
import WidgetKit

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


struct CreateCycleView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var sheetOpen: Bool
    
    @State var duration: Int = 1
    @State var type: CyclePeriodType = CyclePeriodType.days
    @State var startsAt: Date = Date()
    @State var repeats: Bool = true
    @State var repeatFromLastCompleted = true
    @State var name: String = ""
    @State var icon: String = "house"
    
    @State var showDatePicker = false
    @State var showIconPicker = false
    @State var error: String?
    @State var pageId: Int? = 0
    
    private let icons: [String] = [
        "house",
        "person",
        "gear",
        "bell",
        "heart",
        "star",
        "bookmark",
        "message",
        "calendar",
        "camera"
    ]
    
    @MainActor
    func save() {
        if(name.isEmpty){
            error = "Please enter a name"
            return;
        } else if(duration < 1 || (duration == 1 && type == .days)){
            error = "Please enter a valid duration (more than 1)"
            return;
        }
        
        error = nil
        
        let cycle = Cycle(
            name: name,
            icon: icon,
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
                .buttonStyle(.secondary(height: 36))
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
                .frame(height: 36)
                .buttonStyle(.primary(height: 36))
                
                
                Spacer()
                
                Text("repeats")
                    .font(.callout.bold())
                Toggle("Repeats", isOn: $repeats)
                    .labelsHidden()
            }
            
            Divider()
            
            Text("Repeating from")
                .font(.callout.bold())
            
            Picker("Repeat from", selection: $repeatFromLastCompleted){
                Text("Last Completion").tag(true)
                Text("Fixed Interval (\(duration) \(type.label()))")
                    .tag(false)
            }.frame(maxWidth: .infinity)
                .pickerStyle(.palette)
            
            Divider()
            
            Text("Customize")
                .font(.callout.bold())
            
            HStack {
                TextField("Name", text: $name)
                    .textFieldStyle(AppTextFieldStyle())
                    .frame(width: 190)
                
                Spacer()
                
                Button(action: { showIconPicker = true }){
                    HStack{
                        Image(systemName: icon)
                        Text(icon.capitalized)
                    }
                }
                .font(.system(size: 14, weight: .bold))
                .buttonStyle(.primary(height: 36))
                .sheet(isPresented: $showIconPicker){
                    LazyVGrid(columns: .init(repeating: .init(), count: 6), spacing: 16){
                        ForEach(Binding.constant(icons), id: \.self){ icon in
                            Button{
                                self.icon = icon.wrappedValue
                                showIconPicker = false
                            } label: {
                                Image(systemName: icon.wrappedValue)
                                    .imageScale(.large)
                                    .frame(width: 32, height: 32)
                            }
                            .buttonStyle(.secondary(width: 48, height: 48))
                        }
                    }
                    .padding(32)
                    Spacer()
                }
            }
            
            
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
            
            Divider()
            
            Spacer()
            
            GeometryReader{ geo in
                let screenCenter = geo.size.width / 2
                let width: CGFloat = geo.size.width * 0.5
                let padding = geo.size.width - width
                ScrollViewReader{ proxy in
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(spacing: 16){
                            ForEach(0..<5, id: \.self){ index in
                                GeometryReader{geo in
                                    let frame = geo.frame(in: .global)
                                    let frameCenter = frame.midX
                                    let distance = abs(screenCenter - frameCenter)
                                    let maxDistance = geo.size.width/1.5
                                    let scale = max(0.8, 1 - (distance/maxDistance) * 0.2)
                                    
                                    WidgetPreviewView{
                                        CycleWidget(entry: CycleTimelineEntry(date: Date(), id: UUID(), icon: icon, percentage: 0.75, label: "In 2 days", name: name))
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .shadow(radius: 16)
                                    .onTapGesture{
                                        withAnimation{
                                            proxy.scrollTo(index, anchor: .leading)
                                        }
                                    }
                                    .scaleEffect(scale)
                                    .opacity(Double(scale))
                                    .offset(y: geo.size.height/4 * (1 - scale))
                                    
                                }.frame(width: width)
                                    .id(index)
                            }
                        }
                        .padding(.horizontal, padding/2)
                        .scrollTargetLayout()
                    }
                }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $pageId)
                    .scrollClipDisabled(true)
            }
            

                
            Spacer()
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
        CreateCycleView(sheetOpen: $sheetOpen)
            .modelContainer(for: Cycle.self, inMemory: true)
            .tint(.primary)
            .foregroundStyle(Color.foreground)
    }
}
