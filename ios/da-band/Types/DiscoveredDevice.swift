import CoreBluetooth
import Foundation

@Observable
class DiscoveredDevice: Identifiable {
    var id: UUID { peripheral.identifier }
    let peripheral: CBPeripheral
    let name: String
    var rssi: NSNumber
    var sensorDataBuffer = SensorDataBuffer()
    var lastSeen: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()

    init(peripheral: CBPeripheral, name: String, rssi: NSNumber) {
        self.peripheral = peripheral
        self.name = name
        self.rssi = rssi
    }
}
