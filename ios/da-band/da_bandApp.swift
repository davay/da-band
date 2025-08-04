import SwiftData
import SwiftUI

@main
struct da_bandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [Device.self, Gesture.self, Sample.self, Measurement.self, Model.self])
    }
}
