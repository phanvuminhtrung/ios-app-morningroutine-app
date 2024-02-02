//
//  AddRhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftUI

struct AddRhythmView: View {
    @Environment (\.modelContext) var modelContext
    
    @State private var name = ""
    
    var body: some View {
        Form {
            TextField ("Add new rhythm", text: $name)
            
            Section {
                Button ("Save") {
                    let newRhythm = Rhythm(name: name)
                    modelContext.insert(newRhythm)
                }
            }
        }
    
    }
}

#Preview {
    AddRhythmView()
}
