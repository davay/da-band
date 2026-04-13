import Charts
import SwiftUI

struct DeviceSensorView: View {
    let sensorDataBuffer: SensorDataBuffer
    var axis: Axis = .vertical

    var body: some View {
        TimelineView(.periodic(from: .now, by: Constants.chartRefreshInterval)) { _ in let content = Group {
            SingleMuscleActivityChart(dataPoints: sensorDataBuffer.dataPoints)
                .onDisappear {
                    sensorDataBuffer.clear()
                }

            if let latestData = sensorDataBuffer.latest {
                OrientationPreview(sensorData: latestData)
                    .padding(.bottom)
            }

            // Debug chart for packets/sec
            VStack(alignment: .leading) {
                Text("Packets/sec: \(sensorDataBuffer.packetsPerSecond)")
                    .font(.caption2)
                Chart(Array(sensorDataBuffer.packetsPerSecondHistory.enumerated()), id: \.offset) { index, value in
                    LineMark(x: .value("Time", index), y: .value("PPS", value))
                }
                .frame(height: 60)
            }
            .padding(.horizontal)
        }

        if axis == .horizontal {
            HStack { content }
        } else {
            VStack { content }
        }
        }
    }
}
