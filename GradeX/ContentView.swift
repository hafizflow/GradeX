//
//  ContentView.swift
//  GradeX
//
//  Created by Hafizur Rahman on 24/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CgpaView().tabItem { Label("CGPA", systemImage: "square.and.pencil") }
            Text("Statistics").tabItem { Label("Statistics", systemImage: "waveform.path.ecg") }
            Text("Settings").tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(.red)
    }
}

#Preview {
    ContentView()
}
