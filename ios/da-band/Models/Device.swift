import Foundation
import SwiftData

@Model
final class Device {
    var id: UUID // pass in peripheral.identifier
    var name: String
    var bluetoothId: String
    var pairedAt: Date = Date()
    var isConnected: Bool = false

    @Relationship var configurations: [Configuration] = []
    @Relationship(deleteRule: .cascade) var measurements: [Measurement] = []

    /// Initializes a new Device
    /// - Parameters:
    ///     - id: Unique ID for the device. Pass peripheral identifier from CBPeripheral. Same device should always result in the same ID.
    ///     - name: Display name of the device.
    ///     - bluetoothId: Local name of the device.
    init(id: UUID, name: String, bluetoothId: String) {
        self.id = id
        self.name = name
        self.bluetoothId = bluetoothId
    }
}
