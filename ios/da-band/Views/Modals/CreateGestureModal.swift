import SwiftData
import SwiftUI

struct CreateGestureModal: View {
    let currentConfiguration: Configuration
    let onDismiss: () -> Void

    @State private var gestureName: String = ""
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text("Create Configuration")
                    .font(.title3)
                    .fontWeight(.bold)

                VStack(alignment: .leading) {
                    Text("Gesture Name:")
                        .font(.headline)
                    TextField("", text: $gestureName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom)

                    HStack {
                        Button("Cancel") {
                            onDismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)

                        Spacer()

                        Button("Confirm") {
                            let gesture = Gesture(name: gestureName, configuration: currentConfiguration)
                            modelContext.insert(gesture)
                            onDismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .disabled(gestureName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
