import Charts
import SwiftUI

struct MultiMuscleActivityChart: View {
    let dataSeries: [DeviceDataSeries]
    var windowSeconds: Double
    var referenceTime: CFAbsoluteTime?

    var body: some View {
        let now = referenceTime ?? CFAbsoluteTimeGetCurrent()

        return VStack {
            Chart {
                ForEach(dataSeries) { series in
                    let points = series.dataPoints.filter { now - $0.timestamp <= windowSeconds }
                    ForEach(Array(points.enumerated()), id: \.offset) { _, data in
                        LineMark(
                            x: .value("Time", data.timestamp - now),
                            y: .value("Muscle Level", data.muscleLevel)
                        )
                        .foregroundStyle(by: .value("Device", series.name))
                    }
                }
            }
            .chartXScale(domain: -windowSeconds ... 0.0)
            .chartLegend(position: .top, alignment: .top)
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
