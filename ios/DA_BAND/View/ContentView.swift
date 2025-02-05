import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var dataManager: BluetoothManager

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Da-Band")
                    .font(.title)
                    .bold()
                    .padding(.top, 30)

                // Navigate to New Gesture View
                NavigationLink(destination: NewGestureView(dataManager: dataManager)) {
                    Text("New Gestures")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
