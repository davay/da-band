import Charts
import SwiftUI

struct MultiMuscleActivityChart: View {
    let dataSeries: [DeviceDataSeries]

    var body: some View {
        VStack {
            Text("Muscle Activity")
                .font(.headline)

            Chart {
                // align all lines to the right so they share the same position.
                // without this, a reconnecting device starts at x=0 while others are at x=100,
                // making it look like they're at different points in time.
                let maxCount = dataSeries.map { $0.dataPoints.count }.max() ?? 0

                ForEach(dataSeries) { series in
                    let offset = maxCount - series.dataPoints.count

                    ForEach(Array(series.dataPoints.enumerated()), id: \.offset) { index, data in
                        LineMark(
                            x: .value("Sample", index + offset),
                            y: .value("Muscle Level", data.muscleLevel)
                        )
                        .foregroundStyle(by: .value("Device", series.name))
                    }
                }
            }
            .frame(height: 100)
            .chartXScale(domain: 0 ... 100)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine()
                }
            }
            .padding()
        }
    }
}
