import SwiftData
import SwiftUI

struct DevicesView: View {
    @Query(sort: \Device.pairedAt, order: .reverse) private var devices: [Device]
    @Binding var selectedDevice: Device?
    var isModalOpen: Bool
    @Environment(BluetoothManager.self) private var bluetoothManager
    @Environment(\.modelContext) private var modelContext
    @State private var deviceToRename: Device?
    @State private var newDeviceName = ""
    @State private var showRenameAlert = false

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    if devices.isEmpty {
                        Card(widthPercentage: 0.9) {
                            Text("No devices are available")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    } else {
                        ForEach(devices) { device in
                            let isConnected = device.isConnected(in: bluetoothManager)
                            Card(widthPercentage: 0.9) {
                                VStack {
                                    HStack {
                                        StatusIndicator(isActive: isConnected, type: .device)

                                        ScrollView(.horizontal, showsIndicators: false) {
                                            Text(device.name)
                                                .font(.title2)
                                                .lineLimit(1)
                                                .fixedSize()
                                        }

                                        Spacer()

                                        Menu {
                                            Button("Rename") {
                                                newDeviceName = device.name
                                                deviceToRename = device
                                                showRenameAlert = true
                                            }
                                            Button("Delete", role: .destructive) {
                                                modelContext.delete(device)
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundStyle(.black)
                                                .padding(.leading, 12) // so it's easier to tap
                                                .padding(.bottom, 12)
                                                .contentShape(Rectangle()) // so it's easier to tap
                                        }
                                    }

                                    VStack(alignment: .leading) {
                                        Text("Paired On: ").font(.headline) + Text(device.pairedAt.formatted(date: .abbreviated, time: .shortened))
                                        Text("Battery Level: ").font(.headline) + Text(isConnected ? "\(device.batteryLevel(in: bluetoothManager))" : "-")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .onTapGesture {
                                selectedDevice = device
                            }
                        }
                    }

                    Text("Deleting a device removes all associated configurations and samples")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    NavigationLink(destination: PairDeviceView()) {
                        Text("+")
                            .frame(width: 80, height: 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
                // prevents clipping
                .padding(.top, 2)
            }
        }
        .alert("Rename Device", isPresented: $showRenameAlert) {
            TextField("", text: $newDeviceName)
            Button("Cancel") {} // in an alert, the isPresented binding automatically gets set to false whenever any button is pressed, so this is just a no-op
            Button("Rename") {
                deviceToRename?.name = newDeviceName
                deviceToRename = nil
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Device.self, configurations: config)

    MockData.createSampleDevices(in: container)

    return NavigationStack {
        HomeView()
            .toolbar(.hidden, for: .navigationBar)
    }
    .modelContainer(container)
}
