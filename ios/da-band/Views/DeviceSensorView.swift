import SwiftUI

struct DeviceSensorView: View {
    let sensorDataBuffer: SensorDataBuffer
    var axis: Axis = .vertical

    var body: some View {
        let content = Group {
            MuscleActivityChart(dataPoints: sensorDataBuffer.dataPoints)
                .onDisappear {
                    sensorDataBuffer.clear()
                }

            if let latestData = sensorDataBuffer.latest {
                OrientationPreview(sensorData: latestData)
                    .padding(.bottom)
            }
        }

        if axis == .horizontal {
            HStack { content }
        } else {
            VStack { content }
        }
    }
}
