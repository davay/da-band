import Foundation
import SwiftData

enum MockData {
    @MainActor
    static func createSampleDevices(in container: ModelContainer) {
        let deviceNames = [
            "Device 1", "Device 2", "Device 3", "Device 4", "Device 5", "Device 6",
            "Device 7", "Device 8", "Device 9", "Device 10", "Device 11", "Device 12",
        ]

        for idx in 0 ..< deviceNames.count {
            let device = Device(
                id: UUID(),
                name: deviceNames[idx],
                bluetoothId: "DEV-\(String(format: "%03d", idx + 1))",
            )
            if idx == 0 { device.isConnected = true }
            container.mainContext.insert(device)
        }
    }
}
