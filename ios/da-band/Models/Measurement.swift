import Foundation
import SwiftData

@Model
final class Measurement {
    var id: UUID = UUID()
    var index: Int
    var roll: Double
    var pitch: Double
    var yaw: Double
    var muscleLevel: Double
    var avgMuscleLevel: Double
    var spectrum0: Double
    var spectrum1: Double
    var spectrum2: Double
    var spectrum3: Double

    var sample: Sample

    init(index: Int, roll: Double, pitch: Double, yaw: Double, muscleLevel: Double,
         avgMuscleLevel: Double, spectrum0: Double, spectrum1: Double, spectrum2: Double,
         spectrum3: Double, sample: Sample)
    {
        self.index = index
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
        self.muscleLevel = muscleLevel
        self.avgMuscleLevel = avgMuscleLevel
        self.spectrum0 = spectrum0
        self.spectrum1 = spectrum1
        self.spectrum2 = spectrum2
        self.spectrum3 = spectrum3
        self.sample = sample
    }
}
