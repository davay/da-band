import SwiftData
import SwiftUI

struct ConfigurationDetailsView: View {
    let configuration: Configuration

    @State private var showCreateGestureModal = false
    @State private var newConfigurationName = ""
    @State private var showRenameConfigurationAlert = false
    @State private var gestureToRename: Gesture?
    @State private var newGestureName = ""
    @State private var showRenameGestureAlert = false
    @Environment(\.modelContext) private var modelContext
    @Environment(BluetoothManager.self) private var bluetoothManager

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Text("Configuration Details")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Card(widthPercentage: 0.9) {
                    VStack(alignment: .leading, spacing: 0) { // so the status indicators are inline
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text("\(configuration.name)")
                                    .font(.title2)
                                    .underline()
                                    .fixedSize()
                            }

                            Spacer()

                            Button {
                                newConfigurationName = configuration.name
                                showRenameConfigurationAlert = true
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

                        HStack(spacing: 4) {
                            Text("Status:").font(.headline)
                            StatusIndicator(isActive: configuration.isActive, type: .configuration)
                            Text(configuration.isActive ? "Active" : "Inactive")
                        }
                        Text("Created On: ").font(.headline) + Text(configuration.createdAt.formatted(date: .abbreviated, time: .shortened))
                        HStack {
                            Text("Devices:").font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(configuration.devices) { device in
                                        HStack(spacing: 4) {
                                            StatusIndicator(isActive: device.isConnected(in: bluetoothManager), type: .device)
                                            Text(device.name)
                                                .lineLimit(1)
                                                .fixedSize()
                                        }
                                    }
                                }
                                // fix clipping
                                .padding(.leading, 1)
                            }
                        }
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
                // prevent squeezing when keyboard is up
                .frame(height: 200)

                Card(widthPercentage: 0.9) {
                    VStack {
                        HStack {
                            Text("Gestures")
                                .font(.title2)
                                .underline()

                            Spacer()

                            Button("+ Add Gesture") {
                                showCreateGestureModal = true
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        if configuration.gestures.isEmpty {
                            Text("No gestures are available")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(configuration.gestures.sorted(by: { $0.createdAt > $1.createdAt })) { gesture in
                                        NavigationLink(destination: GestureDetailsView(gesture: gesture)) {
                                            // prevent clipping
                                            Card(widthPercentage: 0.99) {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        ScrollView(.horizontal, showsIndicators: false) {
                                                            Text(gesture.name)
                                                                .font(.title3)
                                                                .underline()
                                                                .fixedSize()
                                                        }

                                                        Spacer()

                                                        Menu {
                                                            Button("Rename") {
                                                                newGestureName = gesture.name
                                                                gestureToRename = gesture
                                                                showRenameGestureAlert = true
                                                            }
                                                            Button("Delete", role: .destructive) {
                                                                modelContext.delete(gesture)
                                                            }
                                                        } label: {
                                                            Image(systemName: "ellipsis")
                                                                .foregroundStyle(.black)
                                                                .padding(.leading, 12) // so it's easier to tap
                                                                .padding(.bottom, 12)
                                                                .contentShape(Rectangle()) // so it's easier to tap
                                                        }
                                                    }

                                                    Text("Created On: ").font(.headline) + Text(gesture.createdAt.formatted(date: .abbreviated, time: .shortened))
                                                    // must interpolate or cast using String(), else there wont be a compile error but it will fail to build due to timeout
                                                    Text("Samples Recorded: ").font(.headline) + Text("\(gesture.samples.count)")
                                                    Text("Times Triggered: ").font(.headline) + Text("\(gesture.timesTriggered)")
                                                }
                                            }
                                            // prevent clipping
                                            .padding(.top, 2)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(maxHeight: .infinity)
            }
            // so the text doesnt get pushed up when the keyboard is summoned
            .ignoresSafeArea(.keyboard)

            if showCreateGestureModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showCreateGestureModal = false
                    }

                CreateGestureModal(currentConfiguration: configuration) {
                    showCreateGestureModal = false
                }
            }
        }
        .alert("Rename Configuration", isPresented: $showRenameConfigurationAlert) {
            TextField("", text: $newConfigurationName)
            Button("Cancel") {}
            Button("Rename") {
                if !newConfigurationName.trimmingCharacters(in: .whitespaces).isEmpty {
                    configuration.name = newConfigurationName
                }
            }
        }
        .alert("Rename Gesture", isPresented: $showRenameGestureAlert) {
            TextField("", text: $newGestureName)
            Button("Cancel") {}
            Button("Rename") {
                if !newGestureName.trimmingCharacters(in: .whitespaces).isEmpty {
                    gestureToRename?.name = newGestureName
                    gestureToRename = nil
                }
            }
        }
    }
}
