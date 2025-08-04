import CoreBluetooth
import Foundation

@Observable
class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    var discoveredDevices: [DiscoveredDevice] = []
    var isScanning = false
    var bluetoothState: CBManagerState = .unknown

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = central.state

        switch bluetoothState {
        case .poweredOn:
            print("Bluetooth is powered on")
        default:
            print("Bluetooth not available")
        }
    }

    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber)
    {
        let deviceName = peripheral.name ?? "Unknown Device"

        // only show uMyo devices
        guard let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
              localName.contains("uMyo")
        else {
            return
        }

        let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
        let sensorData = parseManufacturerData(manufacturerData: manufacturerData)

        // update existing device or add new one
        if let existingIndex = discoveredDevices.firstIndex(where: { $0.id == peripheral.identifier }) {
            discoveredDevices[existingIndex].rssi = RSSI
            discoveredDevices[existingIndex].latestManufacturerData = manufacturerData
            discoveredDevices[existingIndex].latestSensorData = sensorData
        } else {
            let device = DiscoveredDevice(
                peripheral: peripheral,
                name: deviceName,
                rssi: RSSI,
                latestManufacturerData: manufacturerData,
                latestSensorData: sensorData
            )
            discoveredDevices.append(device)
        }
    }

    func startScanning() {
        guard let centralManager = centralManager,
              centralManager.state == .poweredOn
        else {
            print("Bluetooth not available")
            return
        }

        discoveredDevices.removeAll()
        isScanning = true
        centralManager.scanForPeripherals(withServices: nil,
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func parseManufacturerData(manufacturerData: Data?) -> SensorData? {
        guard let data = manufacturerData else { return nil }

        // expect exactly 15 bytes
        let len = data.count
        if len < 15 { return nil }

        // Parse data directly - no need to search for headers/delimiters
        var index = 0

        let packetId = Int(data[index])
        index += 1

        let batteryLevel = Int(data[index])
        index += 1

        let spectrum0 = Int16(data[index]) << 8
        index += 1

        let muscleAvg = Int(data[index])
        index += 1

        let spectrum1 = Int16(data[index]) << 8 | Int16(data[index + 1])
        index += 2

        let spectrum2 = Int16(data[index]) << 8 | Int16(data[index + 1])
        index += 2

        let spectrum3 = Int16(data[index]) << 8 | Int16(data[index + 1])
        index += 2

        let quaternionW = Int16(data[index]) << 8 | Int16(data[index + 1])
        index += 2

        let quaternionX = Int16(data[index]) << 8
        index += 1

        let quaternionY = Int16(data[index]) << 8
        index += 1

        let quaternionZ = Int16(data[index]) << 8
        index += 1

        let sensorData = SensorData(
            packetId: packetId,
            batteryLevel: batteryLevel,
            spectrum0: spectrum0,
            muscleAvg: muscleAvg,
            spectrum1: spectrum1,
            spectrum2: spectrum2,
            spectrum3: spectrum3,
            quaternionW: quaternionW,
            quaternionX: quaternionX,
            quaternionY: quaternionY,
            quaternionZ: quaternionZ
        )

        return sensorData
    }
}
