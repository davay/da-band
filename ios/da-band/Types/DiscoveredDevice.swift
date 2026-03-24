import CoreBluetooth
import Foundation
import os

private let logger = Logger(subsystem: "im.devinl.da-band", category: "DiscoveredDevice")

@Observable
class DiscoveredDevice: Identifiable {
    var id: UUID {
        peripheral.identifier
    }

    let peripheral: CBPeripheral
    let name: String
    var sensorDataBuffer: SensorDataBuffer

    // MARK: - Observed

    var rssi: NSNumber
    var batteryLevel: Int = 0

    // MARK: - Internals

    @ObservationIgnored var lastSeen: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    @ObservationIgnored private var lastUIUpdate: CFAbsoluteTime = 0
    @ObservationIgnored private let uiUpdateInterval: CFAbsoluteTime = 1.0
    @ObservationIgnored private var pendingRssi: NSNumber
    @ObservationIgnored private var pendingBatteryLevel: Int = 0

    init(peripheral: CBPeripheral, name: String, rssi: NSNumber) {
        self.peripheral = peripheral
        self.name = name
        self.rssi = rssi
        pendingRssi = rssi
        sensorDataBuffer = SensorDataBuffer()
    }

    /// Called on every callback
    func update(rssi: NSNumber, sensorData: SensorData) {
        lastSeen = CFAbsoluteTimeGetCurrent()
        pendingRssi = rssi
        pendingBatteryLevel = sensorData.batteryLevel

        // Always add sensor data at full rate
        sensorDataBuffer.addDataPoint(sensorData)

        // Throttle UI property updates
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastUIUpdate >= uiUpdateInterval {
            self.rssi = pendingRssi
            batteryLevel = pendingBatteryLevel
            lastUIUpdate = now
            logger.debug("\(self.id.uuidString.prefix(8), privacy: .public): \(self.sensorDataBuffer.packetsPerSecond) packets/sec")
        }
    }
}
