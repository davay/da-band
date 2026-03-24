import Foundation

/// Circular buffer
@Observable
class SensorDataBuffer {
    // MARK: - Observed

    var packetsPerSecond: Int = 0
    var packetsPerSecondHistory: [Int] = []

    // MARK: - Internal

    @ObservationIgnored private var buffer: [SensorData?]
    @ObservationIgnored private var head: Int = 0
    @ObservationIgnored private var count: Int = 0
    @ObservationIgnored private var lastRateUpdate: CFAbsoluteTime = 0
    @ObservationIgnored private var packetCount: Int = 0
    private let capacity: Int
    private let maxHistoryCount: Int = 30

    init(maxPoints: Int = 100) {
        capacity = maxPoints
        buffer = Array(repeating: nil, count: maxPoints)
    }

    /// Returns data points in chronological order (oldest first)
    var dataPoints: [SensorData] {
        guard count > 0 else { return [] }

        var result = [SensorData]()
        result.reserveCapacity(count)

        let start = (head - count + capacity) % capacity
        for i in 0 ..< count {
            let index = (start + i) % capacity
            if let data = buffer[index] {
                result.append(data)
            }
        }
        return result
    }

    var latest: SensorData? {
        guard count > 0 else { return nil }
        let latestIndex = (head - 1 + capacity) % capacity
        return buffer[latestIndex]
    }

    func addDataPoint(_ sensorData: SensorData) {
        buffer[head] = sensorData
        head = (head + 1) % capacity
        if count < capacity {
            count += 1
        }

        // Update rate every second
        packetCount += 1
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastRateUpdate >= 1.0 {
            packetsPerSecond = packetCount

            // without this cap, the chart rendering this history causes slowdowns if left open for long enough
            packetsPerSecondHistory.append(packetCount)
            if packetsPerSecondHistory.count > maxHistoryCount {
                packetsPerSecondHistory.removeFirst()
            }
            packetCount = 0
            lastRateUpdate = now
        }
    }

    func clear() {
        buffer = Array(repeating: nil, count: capacity)
        head = 0
        count = 0
    }
}
