import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var studentName: String
    var cgpa: Double = 0.0
    var studentId: String = ""
    var universityName: String = ""
    var facultyName: String = ""
    var batch: String = ""
}


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


var cards: [Card] = [
    Card(bgColor: CardColors.blue.color, studentName: "Zahid", cgpa: 3.80),
    Card(bgColor: CardColors.pink.color, studentName: "Hafiz", cgpa: 3.85),
    Card(bgColor: CardColors.gray.color, studentName: "Anjum", cgpa: 3.83),
    Card(bgColor: CardColors.purple.color, studentName: "Nishat", cgpa: 3.88),
]
