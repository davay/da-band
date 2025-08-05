import Foundation

@Observable
class SensorDataBuffer {
    var dataPoints: [SensorData] = []
    private let maxPoints = 100

    func addDataPoint(_ sensorData: SensorData) {
        DispatchQueue.main.async {
            self.dataPoints.append(sensorData)

            // remove old points if we exceed max
            if self.dataPoints.count > self.maxPoints {
                self.dataPoints.removeFirst()
            }
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.dataPoints.removeAll()
        }
    }
}
