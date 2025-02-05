import SwiftUI
import SwiftData

@main
struct Da_bandApp: App {
    @StateObject private var dataManager = BluetoothManager()
    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: dataManager)
        }
    }
}
