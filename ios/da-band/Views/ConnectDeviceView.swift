import SwiftUI

struct ConnectDeviceView: View {
    let device: DiscoveredDevice
    @Environment(BluetoothManager.self) private var bluetoothManager
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                MuscleActivityChart(dataPoints: bluetoothManager.sensorDataBuffer.dataPoints)
                    .padding()
                OrientationPreview(sensorData: device.latestSensorData!)
                    .padding()
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Packet ID: \(device.latestSensorData?.packetId ?? 0)")
                Text("Battery Level: \(device.latestSensorData?.batteryLevel ?? 0)")
                Text("Spectrum 0: \(device.latestSensorData?.spectrum0 ?? 0)")
                Text("Muscle Average: \(device.latestSensorData?.muscleAvg ?? 0)")
                Text("Spectrum 1: \(device.latestSensorData?.spectrum1 ?? 0)")
                Text("Spectrum 2: \(device.latestSensorData?.spectrum2 ?? 0)")
                Text("Spectrum 3: \(device.latestSensorData?.spectrum3 ?? 0)")
                Text("Quaternion W: \(device.latestSensorData?.quaternionW ?? 0)")
                Text("Quaternion X: \(device.latestSensorData?.quaternionX ?? 0)")
                Text("Quaternion Y: \(device.latestSensorData?.quaternionY ?? 0)")
                Text("Quaternion Z: \(device.latestSensorData?.quaternionZ ?? 0)")
            }
        }
        .onDisappear {
            bluetoothManager.sensorDataBuffer.clear()
        }
    }
}
