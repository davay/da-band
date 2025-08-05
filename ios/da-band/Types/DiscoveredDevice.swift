import CoreBluetooth
import Foundation

struct DiscoveredDevice: Identifiable {
    var id: UUID { peripheral.identifier }
    let peripheral: CBPeripheral
    let name: String
    var rssi: NSNumber
    var latestSensorData: SensorData?
}
