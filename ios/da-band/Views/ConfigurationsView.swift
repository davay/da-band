import SwiftData
import SwiftUI

struct ConfigurationsView: View {
    @Query private var configurations: [Configuration]

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(configurations) { configuration in
                        Card(widthPercentage: 0.9) {
                            VStack {
                                Text(configuration.name)
                            }
                        }
                    }
                }

                // FIX: style isnt consistent with Devices +
                Button("+", action: {})
                    .frame(width: 80, height: 30)
                    .buttonStyle(.bordered)
            }
        }
        Text("Configurations")
    }
}
