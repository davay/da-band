import Foundation
import SwiftData

@Model
final class Device {
    var id: UUID = UUID()
    var name: String
    var bluetoothId: String
    @Attribute(.unique) var macAddress: String
    var pairedAt: Date = Date()
    var isActive: Bool = false

    @Relationship(deleteRule: .cascade) var gestures: [Gesture] = []
    @Relationship(deleteRule: .cascade) var models: [Model] = []

    init(name: String, bluetoothId: String, macAddress: String) {
        self.name = name
        self.bluetoothId = bluetoothId
        self.macAddress = macAddress
    }
}
