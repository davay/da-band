import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    @State private var recordingDate = Date()
    @State private var countdown: Int? = 3

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

                if let count = countdown {
                    Text("\(count)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    TimelineView(.periodic(from: .now, by: Constants.Chart.refreshInterval)) { _ in
                        MultiMuscleActivityChart(dataSeries: dataSeries)
                    }
                }

                // HStack {
                //     Button()
                // }
            }
        }
        .task {
            for count in stride(from: 3, through: 1, by: -1) {
                countdown = count
                try? await Task.sleep(for: .seconds(1))
            }
            countdown = nil
        }
    }
}
