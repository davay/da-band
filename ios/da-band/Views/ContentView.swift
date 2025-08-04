import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            DevicesView()
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
