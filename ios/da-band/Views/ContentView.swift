import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BluetoothManager.self) private var bluetoothManager
    var body: some View {
        ZStack {
            NavigationStack {
                HomeView()
            }
            .onChange(of: bluetoothManager.bluetoothState) { _, newState in
                if newState == .poweredOn {
                    bluetoothManager.startScanning()
                }
            }
            .tint(.black)
            
            // Build date overlay
            VStack {
                Spacer()
                HStack {
                    Text("Build: \(Date().formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                        .padding(.bottom, 8)
                    Spacer()
                }
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
