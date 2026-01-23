import Foundation

@Observable
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
        // TODO: because removeFirst shifts all remaining elements, this is O(n) at time of insert, though its O(1) when grabbing the buffer.
        // We can swap this around if we implement index-based circular buffer which in theory is more performant, but difference shouldn't be huge.
        // We grab the buffer each frame (~60/sec) while we probably add a point slightly more often than that.
        if dataPoints.count > maxPoints {
            dataPoints.removeFirst()
        }
    }

    func clear() {
        dataPoints.removeAll()
    }
}
