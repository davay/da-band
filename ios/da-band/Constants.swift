import Foundation

enum Constants {
    enum Chart {
        static let refreshInterval: TimeInterval = 1.0 / 30.0 // this divisor is basically the desired FPS
    }

    enum Recording {
        static let sampleDuration: Double = 2
    }
}
