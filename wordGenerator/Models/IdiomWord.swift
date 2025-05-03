import Foundation
import SwiftData

@Model
final class IdiomWord {
    var name: String
    var note: String
    var zhuyin: String
    var interpretation: String?
    var allusionDescription: String?
    var usageDescription: String?
    var example: String?
    var usageCategory: String?
    var mainIdioms: Bool
    
    init(name: String, note: String, zhuyin: String, interpretation: String?, allusionDescription: String?, usageDescription: String?, example: String?, usageCategory: String?, mainIdioms: Bool) {
        self.name = name
        self.note = note
        self.zhuyin = zhuyin
        self.interpretation = interpretation
        self.allusionDescription = allusionDescription
        self.usageDescription = usageDescription
        self.example = example
        self.usageCategory = usageCategory
        self.mainIdioms = mainIdioms
    }
} 
