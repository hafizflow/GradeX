import SwiftData
import SwiftUI

struct AddSemesterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var semesterName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter semester name...", text: $semesterName, axis: .vertical)
            }
            .navigationTitle("Add Semester")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "multiply") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", systemImage: "checkmark") {
                        addSemester()
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(validSemester)
                }
            }
        }
    }
    
    
    var validSemester: Bool {
        semesterName.count < 4 || semesterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func addSemester() {
        let semester = Semester(name: semesterName)
        modelContext.insert(semester)
        dismiss()
    }
}

#Preview {
    AddSemesterView()
}
