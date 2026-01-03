//
//  Course.swift
//  GradeX
//
//  Created by Hafizur Rahman on 4/1/26.
//

import Foundation
import SwiftData


@Model
class Course {
    var courseTitle: String
    var courseCode: String
    var credits: Double
    var grade: Double
    @Relationship(deleteRule: .cascade) var semester: Semester?
    
    init(courseTitle: String, courseCode: String, credits: Double, grade: Double, semester: Semester? = nil) {
        self.courseTitle = courseTitle
        self.courseCode = courseCode
        self.credits = credits
        self.grade = grade
        self.semester = semester
    }
}
