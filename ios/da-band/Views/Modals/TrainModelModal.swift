import os
import SwiftUI

enum TrainingPhase {
    case transmitting, training, downloading, testing
}

struct TrainModelModal: View {
    let onDismiss: () -> Void
    @State private var phase: TrainingPhase = .transmitting
    @State private var trainingResult: String?
    private let logger = Logger(subsystem: "im.devinl.da-band", category: "SensorData")

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack(alignment: .leading) {
                Text("Training...")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom)

                VStack(alignment: .leading, spacing: 16) {
                    Text("1. Transmitting data to server... ").foregroundStyle(phase == .transmitting ? .primary : .secondary)
                    Text("2. Training model...").foregroundStyle(phase == .training ? .primary : .secondary)
                    Text("3. Downloading model...").foregroundStyle(phase == .downloading ? .primary : .secondary)
                    Text("4. Model is ready for testing.").foregroundStyle(phase == .testing ? .primary : .secondary)
                }
                .fontDesign(.monospaced)
                .padding([.leading, .bottom])

                if let result = trainingResult {
                    Text("api.devinl.im: \(result)")
                        .font(.caption)
                        .padding(.bottom)
                }

                HStack {
                    Button("Close") {
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .task {
            do {
                let data = try await APIClient.trainModel()
                trainingResult = String(data: data, encoding: .utf8)
                phase = .testing
            } catch {
                logger.debug("\(error)")
            }
        }
    }
}
