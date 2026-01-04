import SwiftData
import Foundation

@Model
class Semester {
    var name: String
    var courses = [Course]()
    
    init(name: String) {
        self.name = name
    }
    
    var sgpa: Double {
        var totalCredit: Double = 0.0
        var creditPoint: Double = 0.0
        
        for course in courses {
            creditPoint += course.grade * course.credit
            totalCredit += course.credit
        }
        
        return creditPoint / totalCredit
    }
}
