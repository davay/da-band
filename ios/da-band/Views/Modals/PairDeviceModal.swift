import SwiftUI

struct PairDeviceModal: View {
    let device: DiscoveredDevice
    let onDismiss: () -> Void

    @State private var deviceNickname: String = ""

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(BluetoothManager.self) private var bluetoothManager

    /// so that when a device reconnects the modal uses the new reference and show device data properly
    var currentDevice: DiscoveredDevice? {
        bluetoothManager.getDiscoveredDevice(for: device.id)
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text("Pair \(device.name)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                if let currentDevice = currentDevice {
                    (Text("Device ID: ").font(.headline) + Text("\(device.id)"))
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(.horizontal)
                        .padding(.bottom)

                    VStack(alignment: .leading) { // without this alignment the signal is a bit indented
                        Text("Signal Strength: ").font(.headline) + Text("\(currentDevice.rssi) dBm")
                        Text("Battery Level: ").font(.headline) + Text("\(currentDevice.batteryLevel)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // somehow without this the text wouldnt be aligned
                    .padding(.horizontal)
                    .padding(.bottom)

                    TimelineView(.periodic(from: .now, by: Constants.chartRefreshInterval)) { _ in
                        SingleMuscleActivityChart(dataPoints: currentDevice.sensorDataBuffer.dataPoints)
                            .onDisappear {
                                currentDevice.sensorDataBuffer.clear()
                            }

                        // ideally this should only ever be missing for a split second that it wouldn't be noticable
                        if let latestData = currentDevice.sensorDataBuffer.latest {
                            OrientationPreview(sensorData: latestData)
                                .padding(.bottom)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Device Nickname:")
                            .font(.headline)
                        TextField("", text: $deviceNickname)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)

                        HStack {
                            Button("Cancel") {
                                onDismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)

                            Spacer()
                            Button("Pair") {
                                let newDevice = Device(
                                    id: device.id,
                                    name: deviceNickname,
                                    bluetoothId: device.name
                                )

                                modelContext.insert(newDevice)
                                // this custom callback hides the modal
                                onDismiss()
                                // this built-in dismiss exits our current navigation stack
                                dismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .disabled(deviceNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .padding()
                } else {
                    Text("Device offline")
                        .padding()
                }
            }
        }
        // .drawingGroup()
    }
}
