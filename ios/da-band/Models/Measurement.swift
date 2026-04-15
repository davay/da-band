import Foundation
import SwiftData

@Model
final class Measurement {
    var id: UUID = UUID()

    var timestamp: CFAbsoluteTime

    // raw sensor data
    var packetId: Int
    var batteryLevel: Int
    var spectrum0: Int16
    var muscleAvg: Int
    var spectrum1: Int16
    var spectrum2: Int16
    var spectrum3: Int16
    var quaternionW: Int16
    var quaternionX: Int16
    var quaternionY: Int16
    var quaternionZ: Int16

    // computed attributes
    var normalizedSpectrum0: Double
    var normalizedSpectrum1: Double
    var normalizedSpectrum2: Double
    var normalizedSpectrum3: Double
    var normalizedQuaternionW: Double
    var normalizedQuaternionX: Double
    var normalizedQuaternionY: Double
    var normalizedQuaternionZ: Double
    var muscleLevel: Int

    @Relationship var sample: Sample?
    @Relationship var device: Device?

    init(timestamp: CFAbsoluteTime, packetId: Int, batteryLevel: Int, spectrum0: Int16, muscleAvg: Int, spectrum1: Int16,
         spectrum2: Int16, spectrum3: Int16, quaternionW: Int16, quaternionX: Int16, quaternionY: Int16,
         quaternionZ: Int16, normalizedSpectrum0: Double, normalizedSpectrum1: Double,
         normalizedSpectrum2: Double, normalizedSpectrum3: Double, normalizedQuaternionW: Double,
         normalizedQuaternionX: Double, normalizedQuaternionY: Double, normalizedQuaternionZ: Double,
         muscleLevel: Int, sample: Sample, device: Device)
    {
        self.timestamp = timestamp
        self.packetId = packetId
        self.batteryLevel = batteryLevel
        self.spectrum0 = spectrum0
        self.muscleAvg = muscleAvg
        self.spectrum1 = spectrum1
        self.spectrum2 = spectrum2
        self.spectrum3 = spectrum3
        self.quaternionW = quaternionW
        self.quaternionX = quaternionX
        self.quaternionY = quaternionY
        self.quaternionZ = quaternionZ
        self.normalizedSpectrum0 = normalizedSpectrum0
        self.normalizedSpectrum1 = normalizedSpectrum1
        self.normalizedSpectrum2 = normalizedSpectrum2
        self.normalizedSpectrum3 = normalizedSpectrum3
        self.normalizedQuaternionW = normalizedQuaternionW
        self.normalizedQuaternionX = normalizedQuaternionX
        self.normalizedQuaternionY = normalizedQuaternionY
        self.normalizedQuaternionZ = normalizedQuaternionZ
        self.muscleLevel = muscleLevel
        self.sample = sample
        self.device = device
    }
}
