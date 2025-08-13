import SwiftUI

struct ConfigurationDetailsView: View {
    let configuration: Configuration

    var body: some View {
        VStack(spacing: 8) {
            Text("Configuration Details")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Card(widthPercentage: 0.9) {
                VStack {
                    Text("\(configuration.name)")
                        .font(.headline)
                        .underline()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: 100)

            Card(widthPercentage: 0.9) {
                VStack {
                    Text("Model Information")
                        .font(.headline)
                        .underline()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: 200)

            Card(widthPercentage: 0.9) {
                VStack {
                    Text("Gestures")
                        .font(.headline)
                        .underline()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
