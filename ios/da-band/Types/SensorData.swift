import Foundation

struct SensorData {
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

    // AI generated, I don't understand quaternions
    var normalizedQuaternion: (w: Double, x: Double, y: Double, z: Double) {
        let w = Double(quaternionW)
        let x = Double(quaternionX)
        let y = Double(quaternionY)
        let z = Double(quaternionZ)

        let r = sqrt(w * w + x * x + y * y + z * z)
        guard r > 0 else { return (1, 0, 0, 0) }

        let m = 1.0 / r
        return (w * m, x * m, y * m, z * m)
    }

    // AI generated
    // because of the orientation of the device:
    //  - a roll irl results in a pitch
    //  - a pitch irl results in a roll
    var eulerAngles: (roll: Double, pitch: Double, yaw: Double) {
        let q = normalizedQuaternion

        let roll = atan2(2 * (q.w * q.x + q.y * q.z), 1 - 2 * (q.x * q.x + q.y * q.y))
        let pitch = asin(2 * (q.w * q.y - q.z * q.x))
        let yaw = atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.y * q.y + q.z * q.z))

        return (roll, pitch, yaw)
    }
}
