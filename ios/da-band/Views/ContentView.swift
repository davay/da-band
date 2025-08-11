import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            HomeView()
        }
        // WARN: For testing only, delete after
        .onAppear {
            do {
                try modelContext.delete(model: Device.self)
            } catch {}
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
