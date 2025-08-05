import Charts
import SwiftUI

struct MuscleActivityChart: View {
    let dataPoints: [SensorData]

    var body: some View {
        VStack {
            Text("Muscle Activity")
                .font(.headline)

            Chart {
                ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, sensorData in
                    LineMark(
                        x: .value("Sample", index),
                        y: .value("Muscle Level", sensorData.muscleAvg)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine()
                }
            }
        }
    }
}
