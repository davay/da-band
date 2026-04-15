import SwiftData
import SwiftUI

struct ConfigurationsView: View {
    @Query(sort: \Configuration.createdAt, order: .reverse) private var configurations: [Configuration]
    @Binding var showCreateConfigurationModal: Bool
    @Environment(\.modelContext) private var modelContext
    @State private var configurationToRename: Configuration?
    @State private var newConfigurationName = ""
    @State private var showRenameAlert = false

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

                                            let deviceCount = configuration.devices.count
                                            let gestureCount = configuration.gestures.count
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 6) {
                                                    Text(configuration.name)
                                                        .font(.title2)
                                                        .fixedSize()
                                                    Text("[\(deviceCount) device\(deviceCount == 1 ? "" : "s") • \(gestureCount) gesture\(gestureCount == 1 ? "" : "s")]")
                                                        .font(.subheadline)
                                                        .fixedSize()
                                                }
                                            }

                                            Spacer()

                                            Menu {
                                                Button {
                                                    configuration.toggleIsActive(in: modelContext)
                                                } label: {
                                                    Text(configuration.isActive ? "Deactivate" : "Activate")
                                                }

                                                Button("Rename") {
                                                    newConfigurationName = configuration.name
                                                    configurationToRename = configuration
                                                    showRenameAlert = true
                                                }

                                                Button("Delete", role: .destructive) {
                                                    modelContext.delete(configuration)
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundStyle(.black)
                                                    .padding(.leading, 12) // so it's easier to tap
                                                    .padding(.bottom, 12)
                                                    .contentShape(Rectangle()) // so it's easier to tap
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

                    Text("Only one configuration can be active at a time")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button {
                        showCreateConfigurationModal = true
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
        .alert("Rename Configuration", isPresented: $showRenameAlert) {
            TextField("", text: $newConfigurationName)
            Button("Cancel") {}
            Button("Rename") {
                configurationToRename?.name = newConfigurationName
                configurationToRename = nil
            }
        }
    }
}
