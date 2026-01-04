import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var semesters: [Semester]
    @State private var showAddSemesterView: Bool = false
    @State private var showAddCourseView: Bool = false
    @State private var selectedSemester: Semester?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(semesters) { semester in
                    Section {
                        ForEach(semester.courses) { course in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(course.courseTitle).font(.title3.bold())
                                    HStack(alignment: .center, spacing: 0) {
                                        Text("\(course.courseCode) || ").font(.caption)
                                        Text("Credit: \(course.credit, specifier: "%.1f")").font(.caption)
                                    }
                                }
                                Spacer()
                                Text(String(course.grade)).font(.headline)
                                    .padding()
                                    .glassEffect()
                            }
                        }
                        .onDelete { offsets in
                            deleteCourse(from: semester, at: offsets)
                        }
                    } header: {
                        HStack {
                            Text(" \(semester.name) ||")
                                .font(.title3)
                                .fontDesign(.rounded)
                            Text("SGPA: \(semester.sgpa, specifier: "%.2f")")
                                .font(.headline.bold())
                                .fontDesign(.rounded)
                            Spacer()
                            Button("Course", systemImage: "plus") {
                                selectedSemester = semester
                            }
                            .buttonStyle(.glassProminent)
                            .labelStyle(.iconOnly)
                            .tint(.green)
                        }
                        .lineLimit(1)
                    }
                }
            }
            .navigationTitle("GradeX")
            .navigationSubtitle("Calculate || Track || Excel")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar { Button("Add Semester", systemImage: "plus") { showAddSemesterView = true } }
            .sheet(isPresented: $showAddSemesterView) { AddSemesterView() }
            .sheet(item: $selectedSemester) { semester in
                AddCourseView(semester: semester)
            }
        }
    }
    
    private func deleteCourse(from semester: Semester, at offsets: IndexSet) {
        semester.courses.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Semester.self)
}
