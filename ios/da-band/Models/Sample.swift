import Foundation
import SwiftData

@Model
final class Sample {
    var id: UUID = UUID()
    var recordedAt: Date = Date()
    var duration: TimeInterval

    @Relationship var gesture: Gesture

    @Relationship(deleteRule: .cascade) var measurements: [Measurement] = []

    init(duration: TimeInterval, gesture: Gesture) {
        self.duration = duration
        self.gesture = gesture
    }
}
