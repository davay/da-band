import Charts
import SwiftUI

struct SingleMuscleActivityChart: View {
    let dataPoints: [SensorData]
    var windowSeconds: Double = 4.0

    var body: some View {
        let endTime = CFAbsoluteTimeGetCurrent()

        VStack {
            Text("Muscle Activity")
                .font(.headline)

            Chart {
                ForEach(Array(dataPoints.filter { endTime - $0.timestamp <= windowSeconds }.enumerated()), id: \.offset) { _, sensorData in
                    LineMark(
                        x: .value("Time", sensorData.timestamp - endTime),
                        y: .value("Muscle Level", sensorData.muscleLevel)
                    )
                    .foregroundStyle(.gray)
                }
            }
            .frame(height: 100)
            .chartXScale(domain: -windowSeconds ... 0.0)
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    AxisValueLabel()
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                }
            }
            .padding()
        }
    }
}
