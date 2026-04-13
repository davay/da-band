import SwiftData
import SwiftUI

struct DevicesView: View {
    @Query(sort: \Device.pairedAt, order: .reverse) private var devices: [Device]
    @Binding var selectedDevice: Device?
    var isModalOpen: Bool
    @Environment(BluetoothManager.self) private var bluetoothManager
    @Environment(\.modelContext) private var modelContext

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
                            let isActive = !isModalOpen && device.isActive(in: bluetoothManager)
                            Card(widthPercentage: 0.9) {
                                VStack {
                                    HStack {
                                        StatusIndicator(isActive: isActive, type: .device)

                                        Text(device.name)
                                            .font(.title2)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Spacer()

                                        Menu {
                                            Button("Delete", role: .destructive) {
                                                modelContext.delete(device)
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundStyle(.black)
                                                .padding(.leading, 12) // so it's easier to tap
                                                .padding(.bottom, 12)
                                        }
                                    }

                                    VStack(alignment: .leading) {
                                        Text("Paired On: ").font(.headline) + Text(device.pairedAt.formatted(date: .abbreviated, time: .shortened))
                                        Text("Battery Level: ").font(.headline) + Text(isActive ? "\(device.batteryLevel(in: bluetoothManager))" : "-")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .onTapGesture {
                                selectedDevice = device
                            }
                        }
                    }

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
