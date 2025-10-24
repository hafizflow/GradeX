//
//  Card.swift
//  GradeX
//
//  Created by Hafizur Rahman on 24/10/25.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var studentName: String
    var cgpa: Double
    var studentId: String = "5678"
    var universityName: String = "DIU"
    var facultyName: String = "FIST"
    var batch: String = "61"
}


var cards: [Card] = [
    Card(bgColor: .red, studentName: "Hafiz", cgpa: 3.85),
    Card(bgColor: .teal, studentName: "Anjum", cgpa: 3.83),
    Card(bgColor: .purple, studentName: "Nishat", cgpa: 3.88),
    Card(bgColor: .blue, studentName: "Zahid", cgpa: 3.80),
]
