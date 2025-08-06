import Foundation
import SwiftUI

struct SensorData {
    // raw data
    let packetId: Int
    let batteryLevel: Int
    let spectrum0: Int16
    let muscleAvg: Int
    let spectrum1: Int16
    let spectrum2: Int16
    let spectrum3: Int16
    let quaternionW: Int16
    let quaternionX: Int16
    let quaternionY: Int16
    let quaternionZ: Int16

    // computed data
    let normalizedSpectrum0: Double
    let normalizedSpectrum1: Double
    let normalizedSpectrum2: Double
    let normalizedSpectrum3: Double
    let normalizedQuaternionW: Double
    let normalizedQuaternionX: Double
    let normalizedQuaternionY: Double
    let normalizedQuaternionZ: Double

    // as computed in the uMyo library -- using unnormalized spectrums
    // may not be needed? we can try two models one with and one without
    var muscleLevel: Double {
        return spectrum2 + 2 * spectrum3
    }

    // most of these is AI generated, I don't understand quaternions
    var quaternionRotation: Angle {
        let angle = 2 * acos(min(1.0, abs(normalizedQuaternionW))) // Clamp to prevent NaN
        return .radians(angle)
    }

    var quaternionAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
        let sinHalfAngle = sqrt(1 - normalizedQuaternionW * normalizedQuaternionW)

        // If w is negative, flip the axis to get the shorter rotation
        let sign: Double = normalizedQuaternionW < 0 ? -1.0 : 1.0

        // signs modified after testing to make sure its rotation matches IRL
        return (
            x: CGFloat(sign * normalizedQuaternionX / sinHalfAngle),
            y: CGFloat(-sign * normalizedQuaternionZ / sinHalfAngle),
            z: CGFloat(-sign * normalizedQuaternionY / sinHalfAngle)
        )
    }

    static func normalizeQuaternion(w: Int16, x: Int16, y: Int16, z: Int16) -> (w: Double, x: Double, y: Double, z: Double) {
        let dw = Double(w)
        let dx = Double(x)
        let dy = Double(y)
        let dz = Double(z)

        let magnitude = sqrt(dw * dw + dx * dx + dy * dy + dz * dz)
        guard magnitude > 0 else { return (1, 0, 0, 0) }

        let invMag = 1.0 / magnitude
        return (dw * invMag, dx * invMag, dy * invMag, dz * invMag)
    }

    static func normalizeSpectrum(_ value: Int16) -> Double {
        let minValue = Double(Int16.min)
        let maxValue = Double(Int16.max)
        return (Double(value) - minValue) / (maxValue - minValue)
    }

    // initially I was trying to follow the uMyo library and convert to euler angles first,
    // but then I find using quaternions directly to be smoother, and better for ML too.
    // var eulerAngles: (roll: Double, pitch: Double, yaw: Double) {
    //     let q = normalizedQuaternion
    //
    //     let roll = atan2(2 * (q.w * q.x + q.y * q.z), 1 - 2 * (q.x * q.x + q.y * q.y))
    //     let pitch = asin(2 * (q.w * q.y - q.z * q.x))
    //     let yaw = atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.y * q.y + q.z * q.z))
    //
    //     return (roll, pitch, yaw)
    // }
}
