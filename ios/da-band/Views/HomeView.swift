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
                    .foregroundStyle(selectedTab == "configurations" ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedTab == "configurations" ? Color.black : Color.clear)

                    Button("Devices") {
                        selectedTab = "devices"
                    }
                    .foregroundStyle(selectedTab == "devices" ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(selectedTab == "devices" ? Color.black : Color.clear)
                }
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.vertical, 12)
                .padding(.horizontal, 20)

                TabView(selection: $selectedTab) {
                    ConfigurationsView(showCreateConfiguration: $showCreateConfiguration).tag("configurations")
                    DevicesView(selectedDevice: $selectedDevice, isModalOpen: selectedDevice != nil).tag("devices")
                }
                // in liquid glass theres this new toggle at the bottom when using tabviews now, removing it
                .tabViewStyle(.page(indexDisplayMode: .never))
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

            // build date
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
