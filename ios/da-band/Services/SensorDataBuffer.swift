import Foundation

class SensorDataBuffer {
    var dataPoints: [SensorData] = []
    private let maxPoints: Int
    
    init(maxPoints: Int = 100) {
        self.maxPoints = maxPoints
    }

    var latest: SensorData? {
        dataPoints.last
    }

    func addDataPoint(_ sensorData: SensorData) {
        dataPoints.append(sensorData)

        // remove old points if we exceed max
        if dataPoints.count > maxPoints {
            dataPoints.removeFirst()
        }
    }

    func clear() {
        dataPoints.removeAll()
    }
}
