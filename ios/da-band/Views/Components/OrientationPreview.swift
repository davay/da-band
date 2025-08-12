
import SwiftUI

struct OrientationPreview: View {
    let sensorData: SensorData

    var body: some View {
        VStack {
            Text("Device Orientation")
                .font(.headline)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue)
                .frame(width: 100, height: 50)
                // using quaternions -- seems to be smoother
                .rotation3DEffect(
                    sensorData.quaternionRotation,
                    axis: sensorData.quaternionAxis
                )
                // using euler angles
                // .rotation3DEffect(
                //     .radians(sensorData.eulerAngles.roll),
                //     axis: (x: 1, y: 0, z: 0)
                // )
                // .rotation3DEffect(
                //     .radians(sensorData.eulerAngles.yaw),
                //     axis: (x: 0, y: 1, z: 0)
                // )
                // .rotation3DEffect(
                //     .radians(sensorData.eulerAngles.pitch),
                //     axis: (x: 0, y: 0, z: 1)
                // )
                .shadow(radius: 4)
                .padding(.top, 40)
        }
    }
}
