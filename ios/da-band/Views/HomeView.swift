import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = "configurations"

    var body: some View {
        VStack {
            Picker("Tab", selection: $selectedTab) {
                Text("Configurations").tag("configurations")
                Text("Devices").tag("devices")
            }
            .pickerStyle(.segmented)

            TabView(selection: $selectedTab) {
                ConfigurationsView().tag("configurations")
                DevicesView().tag("devices")
            }
        }
        // .hideNavigationBar()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Device.self, configurations: config)

    MockData.createSampleDevices(in: container)

    return NavigationStack {
        HomeView()
            .toolbar(.hidden, for: .navigationBar)
    }
    .modelContainer(container)
}
