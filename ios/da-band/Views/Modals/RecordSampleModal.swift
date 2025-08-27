import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    private var allDevicesAvailable: Bool {
        configuration.devices.allSatisfy { configDevice in
            bluetoothManager.discoveredDevices.contains { discoveredDevice in
                discoveredDevice.id == configDevice.id
            }
        }
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                let date = Date()
                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                ScrollView {
                    LazyVStack {
                        ForEach(configuration.devices) { device in
                            Text("\(device.name)")

                            if let discoveredDevice = bluetoothManager.getDiscoveredDevice(for: device.id) {
                                HStack {
                                    MuscleActivityChart(dataPoints: discoveredDevice.sensorDataBuffer.dataPoints)
                                        .onDisappear {
                                            discoveredDevice.sensorDataBuffer.clear()
                                        }

                                    if let latestData = discoveredDevice.sensorDataBuffer.latest {
                                        OrientationPreview(sensorData: latestData)
                                            .padding(.bottom)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
