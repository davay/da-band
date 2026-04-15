import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let gesture: Gesture
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager
    @Environment(\.modelContext) private var modelContext

    @State private var recordingDate = Date()
    @State private var countdown: Int? = 3
    @State private var recordingStartTime: CFAbsoluteTime?
    @State private var recordedState: (series: [DeviceDataSeries], endTime: CFAbsoluteTime)?
    @State private var isRecordingDone = false
    @State private var savedCount = 0
    @State private var currentTakeSaved = false
    @State private var recordingID = 0

    private let sampleDuration = Constants.sampleDuration

    private var liveSeries: [DeviceDataSeries] {
        guard let startTime = recordingStartTime else { return [] }
        return configuration.devices.compactMap { device in
            guard let discovered = bluetoothManager.getDiscoveredDevice(for: device.id) else { return nil }
            return DeviceDataSeries(
                id: device.id,
                deviceName: device.name,
                dataPoints: discovered.sensorDataBuffer.dataPoints.filter { $0.timestamp >= startTime }
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
        recordedState = nil
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

                // countdown → live recording → recorded snapshot
                Group {
                    if let count = countdown {
                        Text("\(count)..")
                            .font(.system(size: 52, weight: .bold))
                            .foregroundStyle(countdownColor(count))
                            .id(count)
                            .transition(.opacity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let recorded = recordedState {
                        MultiMuscleActivityChart(
                            dataSeries: recorded.series,
                            windowSeconds: sampleDuration,
                            endTime: recorded.endTime
                        )
                    } else {
                        TimelineView(.periodic(from: .now, by: Constants.chartRefreshInterval)) { _ in
                            MultiMuscleActivityChart(
                                dataSeries: liveSeries,
                                windowSeconds: sampleDuration
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
                        Button("Discard") { onDismiss() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.move(edge: .leading).combined(with: .opacity))

                        Spacer()

                        Button("Retry") { restart() }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .transition(.opacity)

                        Spacer()

                        Button("Keep") {
                            // create sample
                            let sample = Sample(duration: sampleDuration, gesture: gesture)
                            modelContext.insert(sample)

                            // create a measurement per data point per device and save to sample
                            guard let series = recordedState?.series else { return }
                            for deviceSeries in series {
                                guard let device = configuration.devices.first(where: { $0.id == deviceSeries.id }) else { continue }
                                for point in deviceSeries.dataPoints {
                                    let measurement = Measurement(
                                        timestamp: point.timestamp,
                                        packetId: point.packetId,
                                        batteryLevel: point.batteryLevel,
                                        spectrum0: point.spectrum0,
                                        muscleAvg: point.muscleAvg,
                                        spectrum1: point.spectrum1,
                                        spectrum2: point.spectrum2,
                                        spectrum3: point.spectrum3,
                                        quaternionW: point.quaternionW,
                                        quaternionX: point.quaternionX,
                                        quaternionY: point.quaternionY,
                                        quaternionZ: point.quaternionZ,
                                        normalizedSpectrum0: point.normalizedSpectrum0,
                                        normalizedSpectrum1: point.normalizedSpectrum1,
                                        normalizedSpectrum2: point.normalizedSpectrum2,
                                        normalizedSpectrum3: point.normalizedSpectrum3,
                                        normalizedQuaternionW: point.normalizedQuaternionW,
                                        normalizedQuaternionX: point.normalizedQuaternionX,
                                        normalizedQuaternionY: point.normalizedQuaternionY,
                                        normalizedQuaternionZ: point.normalizedQuaternionZ,
                                        muscleLevel: point.muscleLevel,
                                        sample: sample,
                                        device: device
                                    )
                                    modelContext.insert(measurement)
                                }
                            }

                            savedCount += 1
                            currentTakeSaved = true
                        }
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
            try? await Task.sleep(for: .seconds(sampleDuration))
            recordedState = (series: liveSeries, endTime: CFAbsoluteTimeGetCurrent())
            isRecordingDone = true
        }
    }
}
