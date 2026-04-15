import Foundation

struct DeviceDataSeries: Identifiable {
    let id: UUID
    let deviceName: String
    let dataPoints: [SensorData]
}
