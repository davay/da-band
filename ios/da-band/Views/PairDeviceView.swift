import SwiftData
import SwiftUI

struct PairDeviceView: View {
    @State private var selectedDevice: DiscoveredDevice?
    @Environment(BluetoothManager.self) private var bluetoothManager
    @Environment(\.dismiss) private var dismiss
    @Query private var pairedDevices: [Device]

    private var unpairedDevices: [DiscoveredDevice] {
        let pairedIds = Set(pairedDevices.map { $0.id })
        return bluetoothManager.discoveredDevices.filter { !pairedIds.contains($0.id) }
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Pair Device")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                if bluetoothManager.bluetoothState != .poweredOn {
                    VStack {
                        Text("Bluetooth Required")
                            .font(.headline)
                        Text("Please enable Bluetooth to scan for devices")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else if unpairedDevices.isEmpty {
                    Text("Searching for unpaired uMyo devices...")
                        .foregroundStyle(.secondary)
                        .frame(maxHeight: .infinity, alignment: .top)
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(unpairedDevices) { device in
                            Card(widthPercentage: 0.9) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(device.name)
                                            .font(.headline)
                                        Text(device.id.uuidString)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .truncationMode(.middle)
                                        Text("Signal: \(device.rssi) dBm")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button("Connect") {
                                        selectedDevice = device
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.black)
                                }
                            }
                        }
                    }
                    // prevents clipping with border
                    .padding(.top, 2)
                }
            }

            ModalOverlay(item: $selectedDevice) { device in
                PairDeviceModal(device: device) { selectedDevice = nil }
            }
        }
    }
}

#Preview {
    return PairDeviceView()
}
