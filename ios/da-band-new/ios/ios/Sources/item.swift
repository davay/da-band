//
//  Item.swift
//  Da-band
//
//  Created by Shihao Xing on 12/16/24.
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
