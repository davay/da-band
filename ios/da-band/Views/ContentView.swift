import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BluetoothManager.self) private var bluetoothManager
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .onChange(of: bluetoothManager.bluetoothState) { _, newState in
            if newState == .poweredOn {
                bluetoothManager.startScanning()
            }
        }
        .tint(.black)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Device.self, configurations: config)

    MockData.createSampleDevices(in: container)

    return ContentView()
        .modelContainer(container)
}
