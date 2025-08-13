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
                                Text(configuration.name)
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
