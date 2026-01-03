//
//  GradeXApp.swift
//  GradeX
//
//  Created by Hafizur Rahman on 24/10/25.
//

import SwiftData
import SwiftUI

@main
struct GradeXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Semester.self)
    }
}
