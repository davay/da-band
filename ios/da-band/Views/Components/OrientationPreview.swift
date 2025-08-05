
import SwiftUI

struct OrientationPreview: View {
    let sensorData: SensorData

    var body: some View {
        VStack {
            Text("Device Orientation")
                .font(.headline)

            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 30)
                .rotation3DEffect(
                    .radians(sensorData.eulerAngles.roll),
                    axis: (x: 1, y: 0, z: 0)
                )
                .rotation3DEffect(
                    .radians(sensorData.eulerAngles.yaw),
                    axis: (x: 0, y: 1, z: 0)
                )
                .rotation3DEffect(
                    .radians(sensorData.eulerAngles.pitch),
                    axis: (x: 0, y: 0, z: 1)
                )
                .shadow(radius: 4)
        }
    }
}
