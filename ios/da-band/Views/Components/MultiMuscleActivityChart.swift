import Charts
import SwiftUI

struct MultiMuscleActivityChart: View {
    let dataSeries: [DeviceDataSeries]
    var windowSeconds: Double
    var endTime: CFAbsoluteTime?

    var body: some View {
        let endTime = endTime ?? CFAbsoluteTimeGetCurrent() // during live recording, end time is not provided, so the chart's right edge tracks the current time and it "scrolls"

        return VStack {
            Chart {
                ForEach(dataSeries) { series in
                    let points = series.dataPoints.filter { endTime - $0.timestamp <= windowSeconds }
                    ForEach(Array(points.enumerated()), id: \.offset) { _, data in
                        LineMark(
                            x: .value("Time", data.timestamp - endTime),
                            y: .value("Muscle Level", data.muscleLevel)
                        )
                        .foregroundStyle(by: .value("Device", series.deviceName))
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
