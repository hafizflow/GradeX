//
//  Course.swift
//  GradeX
//
//  Created by Hafizur Rahman on 24/10/25.
//

import SwiftUI

    // MARK: - Course Model
struct Course: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var credit: Double
    var gpa: Double
}

