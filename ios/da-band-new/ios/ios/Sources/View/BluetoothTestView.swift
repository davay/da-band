import SwiftUI
import CoreBluetooth

struct BluetoothTestView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var isScanning = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Bluetooth Test")
                .font(.title)
                .bold()

            // Start/Stop scanning button
            Button(action: {
                if isScanning {
                    bluetoothManager.stopScanning()
                } else {
                    bluetoothManager.startScanning()
                }
                isScanning.toggle()
            }) {
                Text(isScanning ? "Stop Scanning" : "Start Scanning")
                    .padding()
                    .background(isScanning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Display any discovered data or status
            if let peripheralName = bluetoothManager.foundPeripheralName {
                Text("Found peripheral: \(peripheralName)")
                    .foregroundColor(.purple)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Bluetooth Test")
    }
}
