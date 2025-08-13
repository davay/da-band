import SwiftData
import SwiftUI

struct ConfigurationsView: View {
    @Query private var configurations: [Configuration]
    @Binding var showCreateConfiguration: Bool

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(configurations) { configuration in
                        Card(widthPercentage: 0.9) {
                            VStack {
                                HStack {
                                    StatusIndicator(isActive: configuration.isActive, type: .configuration)

                                    Text(configuration.name)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                Text("\(configuration.devices.count) device(s)")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }

                    Button {
                        showCreateConfiguration = true
                    } label: {
                        Text("+")
                            .frame(width: 80, height: 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
                // prevent clipping
                .padding(.top, 2)
            }
        }
    }
}
