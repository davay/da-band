import Foundation

struct DeviceDataSeries: Identifiable {
    let id: UUID
    let name: String
    let dataPoints: [SensorData]
}
