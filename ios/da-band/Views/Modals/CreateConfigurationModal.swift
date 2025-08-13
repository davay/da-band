import SwiftData
import SwiftUI

struct CreateConfigurationModal: View {
    let onDismiss: () -> Void

    @State private var configurationName: String = ""
    @Query private var devices: [Device]
    @State private var currentStage = 1
    @State private var selectedDevices: Set<UUID> = []
    @Environment(BluetoothManager.self) private var bluetoothManager
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Modal(onDismiss: onDismiss) {
            // stage 1
            if currentStage == 1 {
                VStack {
                    Text("Create Configuration")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(alignment: .leading) {
                        Text("Configuration Name:")
                            .font(.headline)
                        TextField("", text: $configurationName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)

                        HStack {
                            Button("Cancel") {
                                onDismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)

                            Spacer()

                            Button("Continue") {
                                currentStage += 1
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .disabled(configurationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            } else {
                VStack {
                    Text("Select Devices")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(alignment: .leading) {
                        if !devices.isEmpty {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(devices) { device in
                                        Card(widthPercentage: 0.99) {
                                            VStack {
                                                HStack {
                                                    StatusIndicator(isActive: device.isActive(in: bluetoothManager), type: .device)

                                                    Text(device.name)
                                                        .font(.headline)
                                                        .frame(maxWidth: .infinity, alignment: .leading)

                                                    Image(systemName: selectedDevices.contains(device.id) ? "checkmark.square.fill" : "square")
                                                        .foregroundStyle(.gray)
                                                        .font(.title2)
                                                }

                                                (Text("Paired On: ").fontWeight(.bold) + Text("\(device.pairedAt.formatted(date: .abbreviated, time: .shortened))"))
                                                    .font(.subheadline)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        .onTapGesture {
                                            if selectedDevices.contains(device.id) {
                                                selectedDevices.remove(device.id)
                                            } else {
                                                selectedDevices.insert(device.id)
                                            }
                                        }
                                    }
                                }
                                // prevents clipping
                                .padding(.top, 2)
                            }
                            .frame(maxHeight: min(CGFloat(devices.count * 80 + 20), 240))
                        } else {
                            Text("Please pair at least one device")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(.secondary)
                        }

                        NavigationLink(destination: PairDeviceView()) {
                            Text("+ Pair New Device")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .padding(.top)

                        HStack {
                            Button("Back") {
                                currentStage -= 1
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)

                            Spacer()

                            Button("Create") {
                                let configuration = Configuration(name: configurationName)
                                let selectedDeviceObjects = devices.filter { selectedDevices.contains($0.id) }
                                configuration.devices = selectedDeviceObjects
                                modelContext.insert(configuration)
                                onDismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                            .disabled(selectedDevices.isEmpty)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }

            // stage 2
        }
    }
}
