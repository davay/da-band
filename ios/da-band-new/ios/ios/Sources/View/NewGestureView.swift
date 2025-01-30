import SwiftUI

struct NewGestureView: View {
    @EnvironmentObject var dataManager: GestureDataManager
    @State private var countdown = 3
    @State private var isRecording = false
    @State private var recordingComplete = false

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
                    startRecording()
                }
            }

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

    private func startRecording() {
        isRecording = true
        recordingComplete = false
        countdown = 3
        dataManager.startNewGesturesRecording(countdown: countdown) {
            isRecording = false
            // Not working right now, need actually receive complete message from startNew..ording function
            recordingComplete = true
            print("Recording complete.")
        }

        // Simulate countdown
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct NewGestureView_Previews: PreviewProvider {
    static var previews: some View {
        NewGestureView()
            .environmentObject(GestureDataManager())
    }
}
