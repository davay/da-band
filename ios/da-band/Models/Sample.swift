import Foundation
import SwiftData

@Model
final class Sample {
    var id: UUID = UUID()
    var recordedAt: Date = Date()
    var duration: TimeInterval
    var sampleRate: Double

    var gesture: Gesture

    @Relationship(deleteRule: .cascade) var measurements: [Measurement] = []

    init(duration: TimeInterval, sampleRate: Double, gesture: Gesture) {
        self.duration = duration
        self.sampleRate = sampleRate
        self.gesture = gesture
    }
}
