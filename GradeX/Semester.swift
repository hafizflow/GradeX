import SwiftData
import Foundation

@Model
class Semester {
    var name: String
    var sgpa: Double = 0.0
    var courses = [Course]()
    
    init(name: String) {
        self.name = name
    }
    
    var validSemester: Bool {
        name.isEmpty == false
    }
}
