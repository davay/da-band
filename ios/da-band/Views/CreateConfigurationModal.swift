import SwiftUI

struct CreateConfigurationModal: View {
    let onDismiss: () -> Void

    @State private var configurationName: String = ""

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text("Create Configuration")
                    .font(.title3)
                    .fontWeight(.bold)

                VStack(alignment: .leading) {
                    Text("Configuration Name:")
                        .font(.headline)
                    TextField("", text: $configurationName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom)

                    HStack {
                        Button("Cancel") {
                            onDismiss()
                        }
                        .buttonStyle(.borderedProminent)

                        Spacer()
                        Button("Continue") {}
                            .buttonStyle(.borderedProminent)
                            .disabled(configurationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
