import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = "configurations"
    @State private var selectedDevice: Device?

    var body: some View {
        // this logic is here so that the picker can be greyed out too
        ZStack {
            VStack {
                Picker("Tab", selection: $selectedTab) {
                    Text("Configurations").tag("configurations")
                    Text("Devices").tag("devices")
                }
                .pickerStyle(.segmented)

                TabView(selection: $selectedTab) {
                    ConfigurationsView().tag("configurations")
                    DevicesView(selectedDevice: $selectedDevice).tag("devices")
                }
            }

            if let device = selectedDevice {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedDevice = nil
                    }

                DeviceDetailsModal(device: device) {
                    selectedDevice = nil
                }
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
