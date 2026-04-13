import SwiftData
import SwiftUI

struct GestureDetailsView: View {
    let gesture: Gesture

    @State private var showRecordSample = false

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
                            Text("\(gesture.name)")
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
                                print("TODO")
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }

                            Button("+ Record Sample") {
                                showRecordSample = true
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        if gesture.samples.isEmpty {
                            Text("No training samples have been recorded")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack {}
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)

            // this is because of that data refresh issue, configuration is marked as optional
            // but it is guaranteed to exist
            if let configuration = gesture.configuration {
                if showRecordSample {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showRecordSample = false
                        }

                    RecordSampleModal(configuration: configuration) {
                        showRecordSample = false
                    }
                }
            }
        }
    }
}
