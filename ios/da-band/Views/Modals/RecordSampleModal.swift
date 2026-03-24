import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    @State private var recordingDate = Date()

    private var dataSeries: [DeviceDataSeries] {
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

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(recordingDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                TimelineView(.periodic(from: .now, by: Constants.Chart.refreshInterval)) { _ in
                    MultiMuscleActivityChart(dataSeries: dataSeries)
                }
            }
        }
    }
}
