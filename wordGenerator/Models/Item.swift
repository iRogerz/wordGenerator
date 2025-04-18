//
//  Item.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/4/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
