import SwiftUI

struct BluetoothTestView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            Text("Bluetooth Test Page")
                .font(.title)
                .padding()
            
            // Button to start scanning
            Button(action: {
                bluetoothManager.startScanning()
            }) {
                Text("Start Scanning")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // List the discovered peripherals
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Text(peripheral.name ?? "Unknown")
            }
            
            Spacer()
        }
        .onAppear {
            // Start scanning as soon as the view appears
            bluetoothManager.startScanning()
        }
        .padding()
    }
}


