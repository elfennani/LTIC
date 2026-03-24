//
//  CycleDetails.swift
//  LastTimeIChecked
//
//  Created by Nizar Elfennani on 21/3/2026.
//
import SwiftUI

struct CycleDetailView: View {
    let cycle: Cycle
    
    var body: some View {
        VStack(alignment: .center){
            Text(cycle.name)
        }
    }
}
