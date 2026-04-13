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
    @State private var savedCount = 0
    @State private var currentTakeSaved = false
    @State private var recordingID = 0

    private let recordingWindowSeconds = Constants.sampleDuration

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

    private func restart() {
        recordingDate = Date()
        countdown = 3
        recordingStartTime = nil
        frozenState = nil
        isRecordingDone = false
        currentTakeSaved = false
        recordingID += 1
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(recordingDate.formatted(date: .abbreviated, time: .standard))
                    .font(.title3)
                    .fontWeight(.bold)

                Text(savedCount == 0 ? "Perform gesture once · Activity and orientation will be recorded" : "\(savedCount) sample\(savedCount == 1 ? "" : "s") saved")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .animation(.easeOut(duration: Constants.animationDuration), value: savedCount)

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
                        TimelineView(.periodic(from: .now, by: Constants.chartRefreshInterval)) { _ in
                            MultiMuscleActivityChart(
                                dataSeries: recordingSeries,
                                windowSeconds: recordingWindowSeconds
                            )
                        }
                    }
                }
                .animation(.easeOut(duration: Constants.animationDuration), value: countdown)
                .frame(height: 250)

                HStack {
                    if currentTakeSaved {
                        Button("Done") { onDismiss() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.move(edge: .leading).combined(with: .opacity))

                        Spacer()

                        Button("Record Another") { restart() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    } else {
                        Button("Exit") { onDismiss() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.move(edge: .leading).combined(with: .opacity))

                        Spacer()

                        Button("Retry") { restart() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.opacity)

                        Spacer()

                        Button("Keep") { savedCount += 1; currentTakeSaved = true }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .animation(.easeOut(duration: Constants.animationDuration), value: currentTakeSaved)
                .disabled(!isRecordingDone)
                .padding([.top, .horizontal])
            }
            .padding(.vertical)
        }
        .task(id: recordingID) { // id here is so that the task is cancelled and restarted when id changes, otherweise it only runs once on appear
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
