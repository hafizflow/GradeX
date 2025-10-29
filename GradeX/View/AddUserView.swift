import SwiftUI

struct AddUserView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    
    @State private var studentName: String = "Hafiz"
    @State private var studentId: String = ""
    @State private var universityName: String = "DIU"
    @State private var facultyName: String = ""
    @State private var batch: String = ""
    @State private var selectedColor: CardColors = .blue
    
    var onSave: (Card) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(title: "Student Name*", text: $studentName, placeholder: "Enter student name")
                    CustomTextField(title: "Student ID", text: $studentId, placeholder: "Enter student ID")
                    CustomTextField(title: "Batch", text: $batch, placeholder: "Enter batch number")
                    CustomTextField(title: "University Name*", text: $universityName, placeholder: "Enter university")
                    CustomTextField(title: "Faculty Name", text: $facultyName, placeholder: "Enter faculty")
                    
                        // Card Color Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Card Color")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        ColorGridPicker(selectedColor: $selectedColor)
                        
                            // Color Preview Card
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedColor.color)
                            .frame(height: 100)
                            .overlay(alignment: .leading) {
                                Circle()
                                    .fill(selectedColor.color)
                                    .overlay {
                                        Circle()
                                            .fill(.white.opacity(0.15))
                                    }
                                    .scaleEffect(2, anchor: .topLeading)
                                    .offset(x: 170, y: 40)
                            }
                            .overlay {
                                VStack(alignment: .leading, spacing: 4) {
                                    Spacer()
                                    Text(studentName.isEmpty ? "Preview" : studentName)
                                        .font(.title3.bold())
                                        .foregroundStyle(.white)
                                    Text("CGPA: 0.00")
                                        .font(.title.bold())
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add New Student")
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
                            saveCard()
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
                            saveCard()
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
        !studentName.isEmpty &&
        !universityName.isEmpty
    }
    
    private func saveCard() {
        let newCard = Card(
            bgColor: selectedColor.color,
            studentName: studentName,
            studentId: studentId,
            universityName: universityName,
            facultyName: facultyName,
            batch: batch
        )
        
        onSave(newCard)
        dismiss()
    }
}

    // Custom TextField Component
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var autoFocus: Bool = false
    @Environment(\.colorScheme) var scheme
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(scheme == .light ? Color(.systemBackground) : Color(.gray.opacity(0.2)))
                .cornerRadius(12)
                .keyboardType(keyboardType)
                .focused($isFocused)
                .onAppear {
                    if autoFocus {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isFocused = true
                        }
                    }
                }
        }
    }
}



    // Color Grid Picker
struct ColorGridPicker: View {
    @Binding var selectedColor: CardColors
    @Environment(\.colorScheme) var scheme
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(CardColors.allCases) { color in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedColor = color
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.color)
                        .frame(height: 50)
                        .overlay {
                            if selectedColor == color {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white, lineWidth: 3)
                                    .padding(2)
                                
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(color.color.opacity(0.8), lineWidth: 3)
                            }
                        }
                }
            }
        }
        .padding()
        .background(scheme == .light ? Color(.systemBackground) : Color(.gray.opacity(0.2)))
        .cornerRadius(16)
    }
}


#Preview {
    AddUserView { card in
        print("New card: \(card.studentName)")
    }
}
