import SwiftUI

struct DeviceDetailsModal: View {
    let device: Device
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    var discoveredDevice: DiscoveredDevice? {
        bluetoothManager.getDiscoveredDevice(for: device.id)
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(device.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                VStack(alignment: .leading) {
                    Text("BLE ID: ").font(.headline) + Text("\(device.bluetoothId)")
                    (Text("Device ID: ").font(.headline) + Text("\(device.id)"))
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text("Paired On: ").font(.headline) + Text("\(device.pairedAt.formatted(date: .abbreviated, time: .shortened))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)

                if let discoveredDevice = discoveredDevice {
                    VStack(alignment: .leading) {
                        Text("Signal Strength: ").font(.headline) + Text("\(discoveredDevice.rssi) dBm")
                        Text("Battery Level: ").font(.headline) + Text("\(discoveredDevice.sensorDataBuffer.latest?.batteryLevel ?? 0)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom)

                    MuscleActivityChart(dataPoints: discoveredDevice.sensorDataBuffer.dataPoints)
                        .onDisappear {
                            discoveredDevice.sensorDataBuffer.clear()
                        }

                    // ideally this should only ever be missing for a split second that it wouldn't be noticable
                    if let latestData = discoveredDevice.sensorDataBuffer.latest {
                        OrientationPreview(sensorData: latestData)
                            .padding(.bottom)
                    }
                } else {
                    Text("Device is offline")
                        .foregroundStyle(.secondary)
                        .padding()
                }

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
        }
    }
}
