
import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    
    let semesterId: UUID
    let onSave: (Course) -> Void
    
    @State private var courseName: String = "Data Science"
    @State private var credit: String = "3"
    @State private var gpa: String = "3.75"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(title: "Course Name*", text: $courseName, placeholder: "e.g., Data Structure", autoFocus: true)
                    
                    CustomTextField(title: "Credit*", text: $credit, placeholder: "e.g., 3.0", keyboardType: .decimalPad)
                    
                    CustomTextField(title: "GPA*", text: $gpa, placeholder: "e.g., 4.0", keyboardType: .decimalPad)
                    
                        // Info Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)
                            Text("GPA Scale")
                                .font(.subheadline.bold())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("A+ = 4.0    A = 3.75    A- = 3.5")
                            Text("B+ = 3.25  B = 3.0     B- = 2.75")
                            Text("C+ = 2.5    C = 2.25    D = 2.0")
                            Text("F = 0.0")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.bold())
                            .foregroundStyle(.primary)
                    }
                    .tint(.primary)
                    .contentShape(Rectangle())
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if #available(iOS 26.0, *) {
                        Button {
                            saveCourse()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundStyle(isFormValid ? .primary : Color.gray)
                        }
                        .disabled(!isFormValid)
                        .buttonStyle(.glassProminent)
                        .contentShape(Rectangle())
                    } else {
                        Button {
                            saveCourse()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundStyle(isFormValid ? .primary : Color.gray)
                        }
                        .disabled(!isFormValid)
                        .buttonStyle(.borderedProminent)
                        .contentShape(Rectangle())
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !courseName.isEmpty &&
        !credit.isEmpty &&
        !gpa.isEmpty &&
        Double(credit) != nil &&
        Double(gpa) != nil &&
        (Double(gpa) ?? 0) <= 4.0 &&
        (Double(gpa) ?? 0) >= 0
    }
    
    private func saveCourse() {
        guard let creditValue = Double(credit),
              let gpaValue = Double(gpa) else { return }
        
        let newCourse = Course(
            name: courseName,
            credit: creditValue,
            gpa: gpaValue
        )
        
        onSave(newCourse)
        dismiss()
    }
}

#Preview {
    AddCourseView(semesterId: UUID()) { course in
        print("New course: \(course.name)")
    }
}
