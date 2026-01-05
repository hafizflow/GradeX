import SwiftData
import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var courseTitle: String = ""
    @State private var courseCode: String = ""
    @State private var credit: Double = 0.0
    @State private var grade: Double = 0.0
    
    let semester: Semester
    
    let credits = [1, 1.5, 2, 2.5, 3, 3.5, 4]
    let grades = [2.0, 2.25, 2.5, 2.75, 3.0, 3.25, 3.5, 3.75, 4.0]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Course Title*") {
                    TextField("Enter course title...", text: $courseTitle)
                        .submitLabel(.next)
                }
                
                Section("Course Code") {
                    TextField("Enter course code...", text: $courseCode)
                        .submitLabel(.next)
                }
                
                Section("Credits*") {
                    HStack {
                        TextField("Enter couse credits...", value: $credit, format: .number.precision(.fractionLength(1)))
                            .keyboardType(.decimalPad)
                            .submitLabel(.next)
                        
                        Picker("Credits", selection: $credit) {
                            ForEach(credits, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .labelsHidden()
                    }
                }
                Section("Grade*") {
                    HStack {
                        TextField("Enter couse grade...", value: $grade, format: .number.precision(.fractionLength(2)))
                            .keyboardType(.decimalPad)
                            .submitLabel(.done)
                        
                        Picker("Credits", selection: $grade) {
                            ForEach(grades, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .labelsHidden()
                    }
                }
            }
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", systemImage: "checkmark") {
                        addCourse()
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(invalidCourse)
                }
            }
        }
    }
    
    var invalidCourse: Bool {
        courseTitle.isEmpty 
    }
    
    private func addCourse() {
        let course = Course(courseTitle: courseTitle, courseCode: courseCode, credit: credit, grade: grade)
        semester.courses.append(course)
        dismiss()
    }
 }

#Preview {
    AddCourseView(semester: Semester(name: "Fall-25"))
}
