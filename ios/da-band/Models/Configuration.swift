import Foundation
import SwiftData

@Model
final class Configuration {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()
    var isActive: Bool = false

    @Relationship var devices: [Device] = []
    @Relationship(deleteRule: .cascade) var gestures: [Gesture] = []
    @Relationship(deleteRule: .cascade) var models: [Model] = []

    init(name: String) {
        self.name = name
    }
}
