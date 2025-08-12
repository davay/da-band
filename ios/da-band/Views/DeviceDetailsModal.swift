import SwiftUI

struct DeviceDetailsModal: View {
    @Environment(BluetoothManager.self) private var bluetoothManager
    let device: Device
    let onDismiss: () -> Void
    var discoveredDevice: DiscoveredDevice? {
        bluetoothManager.getDiscoveredDevice(for: device.id)
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(device.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top)

                VStack(alignment: .leading) {
                    Text("BLE ID: \(device.bluetoothId)")
                    Text("Device ID: \(device.id)")
                    Text("Paired on: \(device.pairedAt)")
                }
                .padding()
                if let discoveredDevice = discoveredDevice {
                    Text("Signal strength: \(discoveredDevice.rssi) dBm")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                    MuscleActivityChart(dataPoints: discoveredDevice.sensorDataBuffer.dataPoints)
                        .onDisappear {
                            discoveredDevice.sensorDataBuffer.clear()
                        }

                    // ideally this should only ever be missing for a split second that it wouldn't be noticable
                    if let latestData = discoveredDevice.sensorDataBuffer.latest {
                        OrientationPreview(sensorData: latestData)
                            .padding(.top, 2)
                    }
                } else {
                    Text("Device offline")
                        .padding()
                }
            }
            .padding()
            .padding(.bottom, 40)
        }
    }
}
