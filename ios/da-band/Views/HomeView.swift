import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = "configurations"
    @State private var selectedDevice: Device?
    @State private var showCreateConfiguration = false

    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: UIFont.preferredFont(forTextStyle: .title2),
        ], for: .normal)
    }

    var body: some View {
        // this logic is here so that the picker can be greyed out too
        ZStack {
            VStack {
                HStack(spacing: 0) {
                    Button("Configurations") {
                        selectedTab = "configurations"
                    }
                    .foregroundColor(selectedTab == "configurations" ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedTab == "configurations" ? Color.blue : Color.clear)

                    Button("Devices") {
                        selectedTab = "devices"
                    }
                    .foregroundColor(selectedTab == "devices" ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedTab == "devices" ? Color.blue : Color.clear)
                }
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.vertical, 12)
                .padding(.horizontal, 20)

                TabView(selection: $selectedTab) {
                    ConfigurationsView(showCreateConfiguration: $showCreateConfiguration).tag("configurations")
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

            if showCreateConfiguration {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showCreateConfiguration = false
                    }

                CreateConfigurationModal {
                    showCreateConfiguration = false
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
