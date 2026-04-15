import SwiftUI

struct SampleDetailsModal: View {
    let sample: Sample
    let onDismiss: () -> Void

    private var dataSeries: [DeviceDataSeries] {
        guard let devices = sample.gesture?.configuration?.devices else { return [] }
        return devices.map { device in
            let points = sample.measurements
                .filter { $0.device?.id == device.id }
                .sorted { $0.timestamp < $1.timestamp }
                .map { measurement in
                    SensorData(
                        timestamp: measurement.timestamp,
                        packetId: measurement.packetId,
                        batteryLevel: measurement.batteryLevel,
                        spectrum0: measurement.spectrum0,
                        muscleAvg: measurement.muscleAvg,
                        spectrum1: measurement.spectrum1,
                        spectrum2: measurement.spectrum2,
                        spectrum3: measurement.spectrum3,
                        quaternionW: measurement.quaternionW,
                        quaternionX: measurement.quaternionX,
                        quaternionY: measurement.quaternionY,
                        quaternionZ: measurement.quaternionZ,
                        normalizedSpectrum0: measurement.normalizedSpectrum0,
                        normalizedSpectrum1: measurement.normalizedSpectrum1,
                        normalizedSpectrum2: measurement.normalizedSpectrum2,
                        normalizedSpectrum3: measurement.normalizedSpectrum3,
                        normalizedQuaternionW: measurement.normalizedQuaternionW,
                        normalizedQuaternionX: measurement.normalizedQuaternionX,
                        normalizedQuaternionY: measurement.normalizedQuaternionY,
                        normalizedQuaternionZ: measurement.normalizedQuaternionZ
                    )
                }
            return DeviceDataSeries(id: device.id, deviceName: device.name, dataPoints: points)
        }
    }

    private var endTime: CFAbsoluteTime {
        sample.measurements.map(\.timestamp).max() ?? CFAbsoluteTimeGetCurrent()
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(sample.recordedAt.formatted(date: .abbreviated, time: .standard))
                    .font(.title3)
                    .fontWeight(.bold)

                Text("\(sample.measurements.count) measurements · \(String(format: "%.1f", sample.duration))s")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                MultiMuscleActivityChart(
                    dataSeries: dataSeries,
                    windowSeconds: sample.duration,
                    endTime: endTime
                )
                .frame(height: 250)

                HStack {
                    Button("Close") {
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)

                    Spacer()
                }
                .padding()
            }
            .padding(.top)
        }
    }
}
