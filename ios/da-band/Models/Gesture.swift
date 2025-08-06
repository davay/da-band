import Foundation
import SwiftData

@Model
final class Gesture {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()
    var timesTriggered: Int = 0

    @Relationship var configuration: Configuration
    @Relationship(deleteRule: .cascade) var samples: [Sample] = []

    init(name: String, configuration: Configuration) {
        self.name = name
        self.configuration = configuration
    }
}
