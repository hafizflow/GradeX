//
//  Course.swift
//  GradeX
//
//  Created by Hafizur Rahman on 24/10/25.
//

import SwiftUI

struct Course: Identifiable {
    var id: UUID = UUID()
    var name: String
    var credit: Double
    var gpa: Double
}

var courses: [Course] = [
    Course(name: "Data Structure", credit: 2, gpa: 3.75),
    Course(name: "Algorithm", credit: 2, gpa: 4.0),
    Course(name: "Social Science", credit: 2, gpa: 3.75),
    Course(name: "Art of Living", credit: 2, gpa: 4.0),
    
    Course(name: "Bangladesh Studies", credit: 2, gpa: 3.75),
    Course(name: "OOP-2", credit: 2, gpa: 4.0),
    Course(name: "Computer Graphics", credit: 2, gpa: 3.75),
    Course(name: "Information Security", credit: 2, gpa: 4.0),
    
    Course(name: "OOP-1", credit: 2, gpa: 3.75),
    Course(name: "Data Science", credit: 2, gpa: 4.0),
    Course(name: "Artificial Intilegence", credit: 2, gpa: 3.75),
    Course(name: "Social & Professional Ethics", credit: 2, gpa: 4.0),
]
