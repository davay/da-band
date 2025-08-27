import SwiftData
import SwiftUI

struct ConfigurationsView: View {
    @Query(sort: \Configuration.createdAt, order: .reverse) private var configurations: [Configuration]
    @Binding var showCreateConfiguration: Bool
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    if configurations.isEmpty {
                        Card(widthPercentage: 0.9) {
                            Text("No configurations are available")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    } else {
                        ForEach(configurations) { configuration in
                            NavigationLink(destination: ConfigurationDetailsView(configuration: configuration)) {
                                Card(widthPercentage: 0.9) {
                                    VStack {
                                        HStack {
                                            StatusIndicator(isActive: configuration.isActive, type: .configuration)

                                            Text(configuration.name)
                                                .font(.title2)

                                            let deviceCount = configuration.devices.count
                                            let gestureCount = configuration.gestures.count
                                            Text("[\(deviceCount) device\(deviceCount == 1 ? "" : "s") • \(gestureCount) gesture\(gestureCount == 1 ? "" : "s")]")
                                                .font(.subheadline)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            Spacer()

                                            Menu {
                                                Button {
                                                    configuration.toggleIsActive(in: modelContext)
                                                } label: {
                                                    Text(configuration.isActive ? "Deactivate" : "Activate")
                                                }

                                                Button("Delete", role: .destructive) {
                                                    modelContext.delete(configuration)
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundStyle(.black)
                                                    .padding(.leading, 12) // so it's easier to tap
                                                    .padding(.bottom, 12)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                        VStack(alignment: .leading) {
                                            Text("Created On: ").font(.headline) + Text(configuration.createdAt.formatted(date: .abbreviated, time: .shortened))
                                            Text("Last Trained: ").font(.headline) + Text("Never")
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
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
