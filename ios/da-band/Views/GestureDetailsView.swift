import SwiftData
import SwiftUI

struct GestureDetailsView: View {
    let gesture: Gesture

    @State private var showRecordSampleModal = false
    @State private var showDevicesDisconnectedAlert = false
    @State private var selectedSample: Sample?
    @State private var newGestureName = ""
    @State private var showRenameAlert = false

    @Environment(\.modelContext) private var modelContext
    @Environment(BluetoothManager.self) private var bluetoothManager

    private var allDevicesConnected: Bool {
        gesture.configuration?.devices.allSatisfy { $0.isConnected(in: bluetoothManager) } ?? false
    }

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Text("Gesture Details")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Card(widthPercentage: 0.9) {
                    VStack(alignment: .leading) {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text("\(gesture.name)")
                                    .font(.title2)
                                    .underline()
                                    .fixedSize()
                            }

                            Spacer()

                            Button {
                                newGestureName = gesture.name
                                showRenameAlert = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }
                        }

                        Text("Created On: ").font(.headline) + Text(gesture.createdAt.formatted(date: .abbreviated, time: .shortened))
                        Text("Samples Recorded: ").font(.headline) + Text("\(gesture.samples.count)")
                        Text("Times Triggered: ").font(.headline) + Text("\(gesture.timesTriggered)")
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }

                Card(widthPercentage: 0.9) {
                    VStack {
                        HStack {
                            Text("Samples")
                                .font(.title2)
                                .underline()

                            Spacer()

                            Button {
                                for sample in gesture.samples {
                                    modelContext.delete(sample)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }

                            Button("+ Record Sample") {
                                if allDevicesConnected {
                                    showRecordSampleModal = true
                                } else {
                                    showDevicesDisconnectedAlert = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .alert("Devices Offline", isPresented: $showDevicesDisconnectedAlert) {
                                Button("OK", role: .cancel) {}
                            } message: {
                                Text("All devices in this configuration must be connected to record a sample.")
                            }
                        }

                        if gesture.samples.isEmpty {
                            Text("No training samples have been recorded")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(gesture.samples.sorted(by: { $0.recordedAt > $1.recordedAt })) { sample in
                                        // prevent clipping
                                        Card(widthPercentage: 0.99) {
                                            HStack {
                                                Text(sample.recordedAt.formatted(date: .abbreviated, time: .standard))

                                                Spacer()

                                                Menu {
                                                    Button("Delete", role: .destructive) {
                                                        modelContext.delete(sample)
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis")
                                                        .foregroundStyle(.black)
                                                        .padding(.leading, 12) // so it's easier to tap
                                                        .contentShape(Rectangle()) // so it's easier to tap
                                                }
                                            }
                                        }
                                        .onTapGesture {
                                            selectedSample = sample
                                        }
                                    }
                                }
                                // prevent clipping
                                .padding(.top, 2)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)

            // this is because of that data refresh issue, configuration is marked as optional
            // but it is guaranteed to exist
            // COMMENT FROM MONTHS LATER: what data refresh issue again??? note to self: describe issues better
            if let configuration = gesture.configuration {
                if showRecordSampleModal {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showRecordSampleModal = false
                        }

                    RecordSampleModal(configuration: configuration, gesture: gesture) {
                        showRecordSampleModal = false
                    }
                }
            }

            if let sample = selectedSample {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedSample = nil
                    }

                SampleDetailsModal(sample: sample) {
                    selectedSample = nil
                }
            }
        }
        .alert("Rename Gesture", isPresented: $showRenameAlert) {
            TextField("", text: $newGestureName)
            Button("Cancel") {}
            Button("Rename") {
                if !newGestureName.trimmingCharacters(in: .whitespaces).isEmpty {
                    gesture.name = newGestureName
                }
            }
        }
    }
}
