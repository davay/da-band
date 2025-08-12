import SwiftUI

struct PairDeviceModal: View {
    @State private var deviceNickname: String = ""
    @Environment(\.modelContext) private var modelContext
    let device: DiscoveredDevice
    let onDismiss: () -> Void
    @Environment(BluetoothManager.self) private var bluetoothManager

    // so that when a device reconnects the modal uses the new reference and show device data properly
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

                    VStack(alignment: .leading) { // without this one the signal is a bit indented
                        Text("Signal Strength: ").font(.headline) + Text("\(currentDevice.rssi) dBm")
                        Text("Battery Level: ").font(.headline) + Text("\(currentDevice.sensorDataBuffer.latest?.batteryLevel ?? 0)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // somehow without this the text wouldnt be aligned
                    .padding(.horizontal)
                    .padding(.bottom)

                    MuscleActivityChart(dataPoints: currentDevice.sensorDataBuffer.dataPoints)
                        .onDisappear {
                            currentDevice.sensorDataBuffer.clear()
                        }

                    // ideally this should only ever be missing for a split second that it wouldn't be noticable
                    if let latestData = currentDevice.sensorDataBuffer.latest {
                        OrientationPreview(sensorData: latestData)
                            .padding(.bottom)
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

                            Spacer()
                            Button("Pair") {
                                let newDevice = Device(
                                    id: device.id,
                                    name: deviceNickname,
                                    bluetoothId: device.name
                                )

                                modelContext.insert(newDevice)
                                onDismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(deviceNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        // Text("Packet ID: \(device.latestSensorData.packetId)")
                        // Text("Battery Level: \(device.latestSensorData.batteryLevel)")
                        // Text("Spectrum 0: \(device.latestSensorData.spectrum0)")
                        // Text("Muscle Average: \(device.latestSensorData.muscleAvg)")
                        // Text("Spectrum 1: \(device.latestSensorData.spectrum1)")
                        // Text("Spectrum 2: \(device.latestSensorData.spectrum2)")
                        // Text("Spectrum 3: \(device.latestSensorData.spectrum3)")
                        // Text("Quaternion W: \(device.latestSensorData.quaternionW)")
                        // Text("Quaternion X: \(device.latestSensorData.quaternionX)")
                        // Text("Quaternion Y: \(device.latestSensorData.quaternionY)")
                        // Text("Quaternion Z: \(device.latestSensorData.quaternionZ)")
                        // Text("Normalized Spectrum 0: \(device.latestSensorData.normalizedSpectrum0)")
                        // Text("Normalized Spectrum 1: \(device.latestSensorData.normalizedSpectrum1)")
                        // Text("Normalized Spectrum 2: \(device.latestSensorData.normalizedSpectrum2)")
                        // Text("Normalized Spectrum 3: \(device.latestSensorData.normalizedSpectrum3)")
                        // Text("Normalized Quaternion W: \(device.latestSensorData.normalizedQuaternionW)")
                        // Text("Normalized Quaternion X: \(device.latestSensorData.normalizedQuaternionX)")
                        // Text("Normalized Quaternion Y: \(device.latestSensorData.normalizedQuaternionY)")
                        // Text("Normalized Quaternion Z: \(device.latestSensorData.normalizedQuaternionZ)")
                        // Text("Muscle Level: \(device.latestSensorData.muscleLevel)")
                    }
                    .padding()
                } else {
                    Text("Device offline")
                        .padding()
                }
            }
        }
    }
}
