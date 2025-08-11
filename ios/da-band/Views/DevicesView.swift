import SwiftData
import SwiftUI

struct DevicesView: View {
    @Query private var devices: [Device]

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(devices) { device in
                        Card(widthPercentage: 0.9) {
                            Text(device.name)
                        }
                    }
                    NavigationLink(destination: PairDeviceView()) {
                        Text("+")
                            .frame(width: 80, height: 30)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 8)
            }
        }
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
