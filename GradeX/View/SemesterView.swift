import SwiftUI

struct SemesterSectionView: View {
    let semester: Semester
    let cardId: UUID
    let onAddCourse: (UUID, Course) -> Void
    let onDeleteCourse: (UUID, UUID) -> Void
    
    @State private var showingAddCourse = false
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                // Semester Header
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(semester.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 12) {
                            Text("Courses: \(semester.courses.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if !semester.courses.isEmpty {
                                Text("GPA: \(String(format: "%.2f", semester.semesterGPA))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
                // Courses List
            if isExpanded {
                if semester.courses.isEmpty {
                    HStack {
                        Spacer()
                        Text("No courses added")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.vertical, 20)
                        Spacer()
                    }
                } else {
                    ForEach(semester.courses) { course in
                        CourseCardView(course: course) {
                            onDeleteCourse(semester.id, course.id)
                        }
                    }
                }
                
                    // Add Course Button
                Button {
                    showingAddCourse = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Course")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showingAddCourse) {
            AddCourseView(semesterId: semester.id) { course in
                onAddCourse(semester.id, course)
            }
        }
    }
}

struct CourseCardView: View {
    let course: Course
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(course.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("Credit: \(String(format: "%.1f", course.credit))")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer(minLength: 0)
            
            Text(String(format: "%.2f", course.gpa))
                .font(.body)
                .foregroundStyle(.gray)
        }
        .lineLimit(1)
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
