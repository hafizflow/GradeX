import SwiftData
import Foundation

@Model
class Course {
    var courseTitle: String
    var courseCode: String
    var credit: Double
    var grade: Double
    @Relationship(deleteRule: .cascade) var semester: Semester?
    
    init(courseTitle: String, courseCode: String = "", credit: Double, grade: Double, semester: Semester? = nil) {
        self.courseTitle = courseTitle
        self.courseCode = courseCode
        self.credit = credit
        self.grade = grade
        self.semester = semester
    }
}
