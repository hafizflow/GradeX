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
