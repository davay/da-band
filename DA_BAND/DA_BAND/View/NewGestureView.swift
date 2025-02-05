import SwiftUI
import CoreBluetooth

struct NewGestureView: View {
    @StateObject var dataManager: BluetoothManager
    @State private var countdown = 3
    @State private var isRecording = false
    @State private var recordingComplete = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("New Gesture Recording")
                .font(.title)
                .padding()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0.0, to: isRecording ? CGFloat(countdown) / 3.0 : 0.0)
                    .stroke(Color.red, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: countdown)
                    .frame(width: 150, height: 150)

                if isRecording {
                    Text("\(countdown)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                } else if recordingComplete {
                    Text("Finished!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                } else {
                    Text("Start")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                }
            }
            .onTapGesture {
                if !isRecording {
                    isRecording = true
                    startCountdown()
                    dataManager.startScanning()
                }
            }
            
            // Here is the different text under the animated circle
            if isRecording {
                Text("Recording gestures...")
                    .foregroundColor(.red)
            } else if recordingComplete {
                Text("Recording complete.")
                    .foregroundColor(.green)
            } else {
                Text("Tap the red circle to start recording")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationBarTitle("New Gesture", displayMode: .inline)
    }
    
    // For recording countdown animation in circle
    private func startCountdown() {
        timer?.invalidate()
        
        countdown = 3
        recordingComplete = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if countdown > 0 {
                    withAnimation{
                        countdown -= 1
                    }
                } else {
                    recordingComplete = true
                    isRecording = false
                    timer?.invalidate()
                }
            }
        }
    }
}

