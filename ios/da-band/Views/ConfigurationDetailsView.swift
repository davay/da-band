import SwiftUI

struct ConfigurationDetailsView: View {
    let configuration: Configuration

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 8) {
            Text("Configuration Details")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Card(widthPercentage: 0.9) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(configuration.name)")
                            .font(.title2)
                            .underline()

                        Spacer()

                        Button {
                            print("TODO: Edit")
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundStyle(.black)
                        }

                        Button {
                            configuration.toggleIsActive(in: modelContext)
                        } label: {
                            Text(configuration.isActive ? "Deactivate" : "Activate")
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Text("Status: ").font(.headline) + Text(configuration.isActive ? "Active" : "Inactive")

                    Text("Created On: ").font(.headline) + Text(configuration.createdAt.formatted(date: .abbreviated, time: .shortened))

                    Text("Devices: ").font(.headline) + Text(configuration.devices.map(\.name).joined(separator: ", "))
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            Card(widthPercentage: 0.9) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Model Information")
                            .font(.title2)
                            .underline()

                        Spacer()

                        Button {
                            print("TODO: Trash")
                        } label: {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundStyle(.black)
                        }

                        Button("Train Model") {
                            print("TODO: Train Model")
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if configuration.models.isEmpty {
                        Text("No models are available")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {}
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: 200)

            Card(widthPercentage: 0.9) {
                VStack {
                    HStack {
                        Text("Gestures")
                            .font(.title2)
                            .underline()

                        Spacer()

                        Button("+ Add Gesture") {
                            print("TODO: Add Gesture")
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if configuration.gestures.isEmpty {
                        Text("No gestures are available")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {}
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
