import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BluetoothManager.self) private var bluetoothManager
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .onAppear {
            // WARN: For testing only, delete after
            do {
                try modelContext.delete(model: Device.self)
            } catch {}
        }
        .onChange(of: bluetoothManager.bluetoothState) { _, newState in
            if newState == .poweredOn {
                bluetoothManager.startScanning()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Device.self, configurations: config)

    MockData.createSampleDevices(in: container)

    return ContentView()
        .modelContainer(container)
}
