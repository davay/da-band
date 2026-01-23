import SwiftUI

struct RecordSampleModal: View {
    let configuration: Configuration
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    @State private var recordingDate = Date()

    // private var allDevicesAvailable: Bool {
    //     configuration.devices.allSatisfy { configDevice in
    //         bluetoothManager.discoveredDevices.contains { discoveredDevice in
    //             discoveredDevice.id == configDevice.id
    //         }
    //     }
    // }
    //
    //
    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(recordingDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                ScrollView {
                    LazyVStack {
                        ForEach(configuration.devices) { device in
                            Text("\(device.name)")

                            if let discoveredDevice = bluetoothManager.getDiscoveredDevice(for: device.id) {
                                DeviceSensorView(sensorDataBuffer: discoveredDevice.sensorDataBuffer, axis: .horizontal)
                            }
                        }
                        // .drawingGroup()
                    }
                }
            }
        }
    }
}
