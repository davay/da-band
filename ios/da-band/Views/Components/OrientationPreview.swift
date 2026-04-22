import simd
import SwiftUI

struct OrientationPreview: View {
    let sensorData: SensorData

    @State private var sourceQuat: simd_quatd = .init(ix: 0, iy: 0, iz: 0, r: 1)
    @State private var targetQuat: simd_quatd = .init(ix: 0, iy: 0, iz: 0, r: 1)
    @State private var animStartTime: CFAbsoluteTime = 0
    @State private var calibrationQuat: simd_quatd? = nil

    private let animDuration: Double = 0.05

    /// interpolated quaternion for the current frame
    private var currentQuat: simd_quatd {
        let t = min((CFAbsoluteTimeGetCurrent() - animStartTime) / animDuration, 1.0)
        return simd_slerp(sourceQuat, targetQuat, t)
    }

    private var rotation: (angle: Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat)) {
        let q = currentQuat
        let w = q.real
        let angle = 2 * acos(min(1.0, abs(w)))
        let sinHalfAngle = sqrt(max(0, 1 - w * w))

        guard sinHalfAngle > 0.001 else { return (.radians(angle), (x: 0, y: 1, z: 0)) }

        let sign: Double = w < 0 ? -1.0 : 1.0
        // signs adjusted to match real-world orientation
        return (.radians(angle), (
            x: CGFloat(sign * q.imag.x / sinHalfAngle),
            y: CGFloat(-sign * q.imag.z / sinHalfAngle),
            z: CGFloat(-sign * q.imag.y / sinHalfAngle)
        ))
    }

    var body: some View {
        VStack {
            Text("Device Orientation")
                .font(.headline)

            TimelineView(.animation) { _ in
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray)
                    .frame(width: 100, height: 50)
                    .rotation3DEffect(rotation.angle, axis: rotation.axis)
                    .shadow(radius: 4)
                    .padding(.top, 40)
            }
        }
        .onAppear {
            calibrationQuat = nil
            sourceQuat = .init(ix: 0, iy: 0, iz: 0, r: 1)
            targetQuat = .init(ix: 0, iy: 0, iz: 0, r: 1)
            animStartTime = CFAbsoluteTimeGetCurrent()
        }
        .onChange(of: sensorData.timestamp) {
            let sensorQuat = simd_quatd(
                ix: sensorData.normalizedQuaternionX,
                iy: sensorData.normalizedQuaternionY,
                iz: sensorData.normalizedQuaternionZ,
                r: sensorData.normalizedQuaternionW
            )
            // first packet after open: calibrate reference, stay flat
            guard let calibration = calibrationQuat else {
                calibrationQuat = sensorQuat
                return
            }
            let relativeQuat = calibration.inverse * sensorQuat // order matters
            sourceQuat = currentQuat
            targetQuat = relativeQuat
            animStartTime = CFAbsoluteTimeGetCurrent()
        }
    }
}
