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

    // MARK: - Card Colors Enum
enum CardColors: CaseIterable {
    case gray, lightGray, lightPink, lavender, pink, rosePink, peach
    case yellow, mint, teal, cyan, blue, skyBlue, purple
    
    var color: Color {
        switch self {
            case .gray: return Color(red: 0.76, green: 0.73, blue: 0.72)
            case .lightGray: return Color(red: 0.78, green: 0.74, blue: 0.76)
            case .lightPink: return Color(red: 0.84, green: 0.75, blue: 0.82)
            case .lavender: return Color(red: 0.75, green: 0.71, blue: 0.87)
            case .pink: return Color(red: 0.98, green: 0.67, blue: 0.76)
            case .rosePink: return Color(red: 0.84, green: 0.67, blue: 0.73)
            case .peach: return Color(red: 0.91, green: 0.75, blue: 0.63)
            case .yellow: return Color(red: 0.85, green: 0.79, blue: 0.57)
            case .mint: return Color(red: 0.67, green: 0.84, blue: 0.70)
            case .teal: return Color(red: 0.65, green: 0.83, blue: 0.82)
            case .cyan: return Color(red: 0.60, green: 0.80, blue: 0.84)
            case .blue: return Color(red: 0.53, green: 0.73, blue: 0.85)
            case .skyBlue: return Color(red: 0.63, green: 0.71, blue: 0.85)
            case .purple: return Color(red: 0.70, green: 0.69, blue: 0.84)
        }
    }
}

extension CardColors: Identifiable {
    var id: Self { self }
    
    var name: String {
        switch self {
            case .blue: return "Blue"
            case .pink: return "Pink"
            case .gray: return "Gray"
            case .purple: return "Purple"
            default: return "Color"
        }
    }
}
