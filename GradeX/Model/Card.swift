import SwiftUI

    // MARK: - Semester Model
struct Semester: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var courses: [Course] = []
    
    var totalCredits: Double {
        courses.reduce(0) { $0 + $1.credit }
    }
    
    var semesterGPA: Double {
        guard !courses.isEmpty else { return 0.0 }
        let totalPoints = courses.reduce(0.0) { $0 + ($1.gpa * $1.credit) }
        return totalPoints / totalCredits
    }
}

    // MARK: - Card Model
struct Card: Identifiable, Codable {
    var id: UUID = UUID()
    var bgColor: Color
    var studentName: String
    var studentId: String = ""
    var universityName: String = ""
    var facultyName: String = ""
    var batch: String = ""
    var semesters: [Semester] = []
    
    var cgpa: Double {
        guard !semesters.isEmpty else { return 0.0 }
        let allCourses = semesters.flatMap { $0.courses }
        guard !allCourses.isEmpty else { return 0.0 }
        
        let totalCredits = allCourses.reduce(0) { $0 + $1.credit }
        let totalPoints = allCourses.reduce(0.0) { $0 + ($1.gpa * $1.credit) }
        
        return totalCredits > 0 ? totalPoints / totalCredits : 0.0
    }
    
        // Custom Codable implementation for Color
    enum CodingKeys: String, CodingKey {
        case id, bgColor, studentName, studentId, universityName, facultyName, batch, semesters
    }
    
    init(id: UUID = UUID(), bgColor: Color, studentName: String, studentId: String = "",
         universityName: String = "", facultyName: String = "", batch: String = "", semesters: [Semester] = []) {
        self.id = id
        self.bgColor = bgColor
        self.studentName = studentName
        self.studentId = studentId
        self.universityName = universityName
        self.facultyName = facultyName
        self.batch = batch
        self.semesters = semesters
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        studentName = try container.decode(String.self, forKey: .studentName)
        studentId = try container.decode(String.self, forKey: .studentId)
        universityName = try container.decode(String.self, forKey: .universityName)
        facultyName = try container.decode(String.self, forKey: .facultyName)
        batch = try container.decode(String.self, forKey: .batch)
        semesters = try container.decode([Semester].self, forKey: .semesters)
        
        let colorComponents = try container.decode([Double].self, forKey: .bgColor)
        bgColor = Color(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2])
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(studentName, forKey: .studentName)
        try container.encode(studentId, forKey: .studentId)
        try container.encode(universityName, forKey: .universityName)
        try container.encode(facultyName, forKey: .facultyName)
        try container.encode(batch, forKey: .batch)
        try container.encode(semesters, forKey: .semesters)
        
        let uiColor = UIColor(bgColor)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode([Double(red), Double(green), Double(blue)], forKey: .bgColor)
    }
}

