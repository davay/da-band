import Foundation

enum Constants {
    static let animationDuration: Double = 0.3
    static let chartRefreshInterval: TimeInterval = 1.0 / 60.0 // this divisor is basically the desired FPS
    static let sampleDuration: Double = 2
    static let ppsHistoryWindow: Int = 20 // seconds of packets/sec history to retain
}
