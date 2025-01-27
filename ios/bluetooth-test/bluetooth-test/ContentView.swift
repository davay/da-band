import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Main Page")
                    .font(.title)
                    .padding(.top, 50)
                
                // Navigation link to BluetoothTestView
                NavigationLink(destination: BluetoothTestView()) {
                    Text("Go to Bluetooth Test Page")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .navigationTitle("Home")
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
