import CoreBluetooth
import Foundation
import os
import SwiftData

private let logger = Logger(subsystem: "im.devinl.da-band", category: "SensorData")

@Observable
class BluetoothManager: NSObject, CBCentralManagerDelegate {
    // MARK: - Observed

    var discoveredDevices: [DiscoveredDevice] = []
    var isScanning = false
    var bluetoothState: CBManagerState = .unknown

    // MARK: - Internals

    @ObservationIgnored private var centralManager: CBCentralManager?
    @ObservationIgnored private var cleanupTimer: Timer?
    @ObservationIgnored private var restartScanTimer: Timer? // anti-throttling measure
    private let deviceTimeout: TimeInterval = 1
    private let cleanupInterval: TimeInterval = 0.9
    private let scanRestartInterval: TimeInterval = 10.0

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        startCleanupTimer()
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

        guard let manufacturerData =
            advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
            let sensorData = parseManufacturerData(manufacturerData: manufacturerData)
        else {
            return
        }

        // update existing device or add new one
        if let existingIndex = discoveredDevices.firstIndex(where: { $0.id == peripheral.identifier }) {
            discoveredDevices[existingIndex].update(rssi: RSSI, sensorData: sensorData)
        } else {
            let device = DiscoveredDevice(
                peripheral: peripheral,
                name: deviceName,
                rssi: RSSI
            )
            device.update(rssi: RSSI, sensorData: sensorData)
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

    private func restartScanning() {
        guard isScanning, let centralManager = centralManager else { return }
        logger.debug("restarting scan to reset iOS BLE throttle")
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil,
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    private func parseManufacturerData(manufacturerData: Data?) -> SensorData? {
        guard let data = manufacturerData else { return nil }

        // expect exactly 15 bytes
        let len = data.count
        if len < 15 { return nil }

        // parse data
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

        // Calculate normalized values using helper methods
        let normalizedQuaternion = SensorData.normalizeQuaternion(w: quaternionW, x: quaternionX, y: quaternionY, z: quaternionZ)

        return SensorData(
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
            quaternionZ: quaternionZ,
            normalizedSpectrum0: SensorData.normalizeSpectrum(spectrum0),
            normalizedSpectrum1: SensorData.normalizeSpectrum(spectrum1),
            normalizedSpectrum2: SensorData.normalizeSpectrum(spectrum2),
            normalizedSpectrum3: SensorData.normalizeSpectrum(spectrum3),
            normalizedQuaternionW: normalizedQuaternion.w,
            normalizedQuaternionX: normalizedQuaternion.x,
            normalizedQuaternionY: normalizedQuaternion.y,
            normalizedQuaternionZ: normalizedQuaternion.z
        )
    }

    func getDiscoveredDevice(for deviceId: UUID) -> DiscoveredDevice? {
        return discoveredDevices.first(where: { $0.id == deviceId })
    }

    private func startCleanupTimer() {
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: cleanupInterval, repeats: true) { _ in
            self.removeStaleDevices()
        }
        restartScanTimer = Timer.scheduledTimer(withTimeInterval: scanRestartInterval, repeats: true) { _ in
            self.restartScanning()
        }
    }

    private func removeStaleDevices() {
        let now = CFAbsoluteTimeGetCurrent()
        guard discoveredDevices.contains(where: { now - $0.lastSeen > deviceTimeout }) else { return }
        discoveredDevices.removeAll { now - $0.lastSeen > deviceTimeout }
    }

    deinit {
        cleanupTimer?.invalidate()
        restartScanTimer?.invalidate()
    }
}
