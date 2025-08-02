import Foundation
import SwiftData

@Model
final class Gesture {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()
    var timesTriggered: Int = 0

    var device: Device

    @Relationship(deleteRule: .cascade) var samples: [Sample] = []

    init(name: String, device: Device) {
        self.name = name
        self.device = device
    }
}
