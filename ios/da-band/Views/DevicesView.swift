import SwiftData
import SwiftUI

struct DevicesView: View {
    @Query private var devices: [Device]

    var body: some View {
        VStack {
            HStack {
                Text("Devices")
                    .font(.largeTitle)
                Spacer()
                NavigationLink("+ Add Device", destination: AddDeviceView())
            }
            .padding()

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(devices) { device in
                        Card(widthPercentage: 0.9) {
                            Text(device.name)
                        }
                    }
                }
                .padding(.top, 8)
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
        DevicesView()
            .toolbar(.hidden, for: .navigationBar)
    }
    .modelContainer(container)
}
