import Foundation
import SwiftData

@Model
final class Model {
    var id: UUID = UUID()
    var trainedAt: Date = Date()
    var samplesUsed: Int
    var supportedGestureIds: [UUID]
    var isActive: Bool = false
    var model: Data
    var accuracy: Double
    var f1Score: Double
    var precision: Double
    var recall: Double

    var device: Device

    init(samplesUsed: Int, supportedGestureIds: [UUID], model: Data, accuracy: Double,
         f1Score: Double, precision: Double, recall: Double, device: Device)
    {
        self.samplesUsed = samplesUsed
        self.supportedGestureIds = supportedGestureIds
        self.model = model
        self.accuracy = accuracy
        self.f1Score = f1Score
        self.precision = precision
        self.recall = recall
        self.device = device
    }
}
