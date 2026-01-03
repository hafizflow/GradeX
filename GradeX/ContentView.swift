import SwiftData
import SwiftUI

struct ContentView: View {
    @Query var semesters: [Semester]
    @State private var showAddSemesterView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(semesters) { semester in
                    Section(semester.name) {
                        ForEach(semester.courses) { course in
                            Text(course.courseTitle)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("GradeX")
            .navigationSubtitle("Calculate || Track || Excel")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar { Button("Add Semester", systemImage: "plus") { showAddSemesterView = true } }
            .sheet(isPresented: $showAddSemesterView) {
                AddSemesterView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Semester.self)
}
