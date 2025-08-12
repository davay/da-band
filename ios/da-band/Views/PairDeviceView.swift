import SwiftData
import SwiftUI

struct PairDeviceView: View {
    @State private var selectedDevice: DiscoveredDevice?
    @Environment(BluetoothManager.self) private var bluetoothManager
    @Query private var pairedDevices: [Device]

    private var unpairedDevices: [DiscoveredDevice] {
        let pairedIds = Set(pairedDevices.map { $0.id })
        return bluetoothManager.discoveredDevices.filter { !pairedIds.contains($0.id) }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Pair Device")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding()

                if bluetoothManager.bluetoothState != .poweredOn {
                    VStack {
                        Text("Bluetooth Required")
                            .font(.headline)
                        Text("Please enable Bluetooth to scan for devices")
                            .foregroundColor(.secondary)
                    }
                    .padding()
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
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button("Connect") {
                                        selectedDevice = device
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            // .hideNavigationBar()

            if let device = selectedDevice {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedDevice = nil
                    }

                PairDeviceModal(device: device) {
                    selectedDevice = nil
                }
            }
        }
    }
}

#Preview {
    return PairDeviceView()
}
