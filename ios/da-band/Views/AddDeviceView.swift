import SwiftData
import SwiftUI

struct AddDeviceView: View {
    @State private var isShowingSheet = false
    @Environment(BluetoothManager.self) private var bluetoothManager

    var body: some View {
        VStack {
            HStack {
                Text("Add Device")
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
                    ForEach(bluetoothManager.discoveredDevices) { device in
                        Card(widthPercentage: 0.9) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(device.name)
                                        .font(.headline)
                                    Text(device.id.uuidString)
                                        .font(.caption)
                                    Text("Signal: \(device.rssi) dBm")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button("Connect") {
                                    isShowingSheet = true
                                }
                                .sheet(isPresented: $isShowingSheet) {
                                    ConnectDeviceView(device: device)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        // .hideNavigationBar()
        .onAppear {
            if bluetoothManager.bluetoothState == .poweredOn {
                bluetoothManager.startScanning()
            }
        }
    }
}

#Preview {
    return AddDeviceView()
}
