import SwiftData
import SwiftUI

@main
struct da_bandApp: App {
    @State private var bluetoothManager = BluetoothManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(bluetoothManager)
        }
        .modelContainer(for: [Device.self, Gesture.self, Sample.self, Measurement.self, Model.self])
    }
}
