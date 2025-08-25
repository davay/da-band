import SwiftData
import SwiftUI

struct ConfigurationDetailsView: View {
    let configuration: Configuration

    @State private var showCreateGesture = false
    @Environment(\.modelContext) private var modelContext

    // since configuration is passed in as a parameter, its value doesn't update after adding a gesture
    // hence this predicate that filters out appropriate gestures
    @Query private var gestures: [Gesture]
    init(configuration: Configuration) {
        self.configuration = configuration
        // fixes "cannot convert value of type 'PredicateExpressions.Equal<...> to closure result type 'any StandardPredicateExpression<Bool>'"
        // this is because Predicate is a macro (transformed at compile time), and it has limitations
        let configurationID = configuration.id
        // behind a swiftui property wrapper, theres an underscore version that manages the underlying wrapper object
        // @Query property means its holding a Query object, a @State property holds a State object, and so on
        _gestures = Query(filter: #Predicate<Gesture> { gesture in
            gesture.configuration.id == configurationID
        }, sort: \Gesture.createdAt, order: .reverse)
    }

    var body: some View {
        ZStack {
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
                                showCreateGesture = true
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        ScrollView {
                            LazyVStack {
                                if gestures.isEmpty {
                                    Text("No gestures are available")
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                } else {
                                    ForEach(gestures) { gesture in
                                        // prevent clipping
                                        Card(widthPercentage: 0.99) {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(gesture.name)
                                                        .font(.headline)

                                                    Spacer()

                                                    Menu {
                                                        Button("Delete", role: .destructive) {
                                                            modelContext.delete(gesture)
                                                        }
                                                    } label: {
                                                        Image(systemName: "ellipsis")
                                                            .foregroundStyle(.black)
                                                            .padding(.leading, 12)
                                                            .padding(.bottom, 12)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(maxHeight: .infinity)
            }

            if showCreateGesture {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showCreateGesture = false
                    }

                CreateGestureModal(currentConfiguration: configuration) {
                    showCreateGesture = false
                }
            }
        }
    }
}
