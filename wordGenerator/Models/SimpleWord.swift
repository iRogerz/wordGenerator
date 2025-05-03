import Foundation
import SwiftData

@Model
final class SimpleWord {
    var name: String
    var note: String
    var zhuyin: String
    
    init(name: String, note: String, zhuyin: String) {
        self.name = name
        self.note = note
        self.zhuyin = zhuyin
    }
} 