import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = GestureDataManager()
    @State private var predictionResult: String? = nil
    @State private var isProcessingPrediction: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Da-Band")
                    .font(.title)
                    .bold()
                    .padding(.top, 30)

                // Navigate to New Gesture View
                NavigationLink(destination: NewGestureView().environmentObject(dataManager)) {
                    Text("New Gestures")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }

                // 'Use Gestures' button
                Button(action: {
                    if let model = dataManager.model, !dataManager.isRecording {
                        isProcessingPrediction = true
                        GestureProcessor.useGestures(
                            model: model,
                            gestureData: dataManager.gestureData,
                            predictionResult: &predictionResult
                        )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // Assuming 2 seconds delay for demo purpose.
                            isProcessingPrediction = false
                        }
                    }
                }) {
                    Text("Use Gestures")
                        .padding()
                        .background(dataManager.model == nil ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(dataManager.model == nil || dataManager.isRecording ? 0.6 : 1.0)
                }
                .disabled(dataManager.model == nil || dataManager.isRecording)

                // Loading indicator while prediction is processing
                if isProcessingPrediction {
                    ProgressView("Processing...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }

                // Show prediction result
                if let result = predictionResult {
                    Text("Prediction: \(result)")
                        .foregroundColor(.purple)
                        .font(.title2)
                        .padding(.top, 10)
                }

                // Current label for recorded gestures
                Text("Recorded Gestures: \(dataManager.currentLabel)")
                    .padding(.top, 10)
                    .foregroundColor(.gray)

                // Bluetooth Test Page Navigation Button
                NavigationLink(destination: BluetoothTestView()) {
                    Text("Go to Bluetooth Test Page")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                // Maybe initiate setup of model or load data
                dataManager.loadModelIfNeeded()
            }
        }
    }
}
