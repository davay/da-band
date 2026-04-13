import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    @State private var recordingDate = Date()
    @State private var countdown: Int? = 3
    @State private var recordingStartTime: CFAbsoluteTime?
    @State private var frozenState: (series: [DeviceDataSeries], referenceTime: CFAbsoluteTime)?
    @State private var isRecordingDone = false

    private let recordingWindowSeconds = Constants.Recording.sampleDuration

    private var liveSeries: [DeviceDataSeries] {
        configuration.devices.compactMap { device in
            guard let discovered = bluetoothManager.getDiscoveredDevice(for: device.id) else {
                return nil
            }
            return DeviceDataSeries(
                id: device.id,
                name: device.name,
                dataPoints: discovered.sensorDataBuffer.dataPoints
            )
        }
    }

    /// essentially a snapshot from the liveseries
    private var recordingSeries: [DeviceDataSeries] {
        guard let startTime = recordingStartTime else { return [] }
        return liveSeries.map { series in
            DeviceDataSeries(
                id: series.id,
                name: series.name,
                dataPoints: series.dataPoints.filter { $0.timestamp >= startTime }
            )
        }
    }

    private func countdownColor(_ count: Int) -> Color {
        switch count {
        case 3: return .green
        case 2: return .orange
        default: return .red
        }
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(recordingDate.formatted(date: .abbreviated, time: .standard))
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Perform gesture once · Activity and orientation will be recorded")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // start from countdown, to empty chart slowly being filled, to frozen
                Group {
                    if let count = countdown {
                        Text("\(count)..")
                            .font(.system(size: 52, weight: .bold))
                            .foregroundStyle(countdownColor(count))
                            .id(count)
                            .transition(.opacity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let frozen = frozenState {
                        MultiMuscleActivityChart(
                            dataSeries: frozen.series,
                            windowSeconds: recordingWindowSeconds,
                            referenceTime: frozen.referenceTime
                        )
                    } else {
                        TimelineView(.periodic(from: .now, by: Constants.Chart.refreshInterval)) { _ in
                            MultiMuscleActivityChart(
                                dataSeries: recordingSeries,
                                windowSeconds: recordingWindowSeconds
                            )
                        }
                    }
                }
                .animation(.easeOut(duration: 0.25), value: countdown)
                .frame(height: 250)

                HStack {
                    Button("Discard") {}
                        .buttonStyle(.borderedProminent)
                        .tint(.black)

                    Spacer()

                    Button("Retry") {}
                        .buttonStyle(.borderedProminent)
                        .tint(.black)

                    Spacer()

                    Button("Keep") {}
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                }
                .disabled(!isRecordingDone)
                .padding([.top, .horizontal])
            }
            .padding(.vertical)
        }
        .task {
            for count in stride(from: 3, through: 1, by: -1) {
                countdown = count
                try? await Task.sleep(for: .seconds(1))
            }
            countdown = nil
            recordingStartTime = CFAbsoluteTimeGetCurrent()
            try? await Task.sleep(for: .seconds(recordingWindowSeconds))
            frozenState = (series: recordingSeries, referenceTime: CFAbsoluteTimeGetCurrent())
            isRecordingDone = true
        }
    }
}
