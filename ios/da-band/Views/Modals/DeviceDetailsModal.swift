import Charts
import SwiftUI

private struct DeviceSensorSection: View {
    let sensorDataBuffer: SensorDataBuffer
    var axis: Axis = .vertical

    var body: some View {
        TimelineView(.periodic(from: .now, by: Constants.chartRefreshInterval)) { _ in let content = Group {
            SingleMuscleActivityChart(dataPoints: sensorDataBuffer.dataPoints)
                .onDisappear {
                    sensorDataBuffer.clear()
                }

            if let latestData = sensorDataBuffer.latest {
                OrientationPreview(sensorData: latestData)
                    .padding(.bottom)

                // debugging quaternions
                VStack {
                    Text("Raw Quaternions")
                        .font(.caption2).bold()
                    Text("W: \(latestData.quaternionW)  X: \(latestData.quaternionX)  Y: \(latestData.quaternionY)  Z: \(latestData.quaternionZ)")
                        .font(.caption2)
                        .fontDesign(.monospaced)
                    Text("Normalized Quaternions")
                        .font(.caption2).bold()
                        .padding(.top, 2)
                    Text("W: \(latestData.normalizedQuaternionW, specifier: "%.3f")  X: \(latestData.normalizedQuaternionX, specifier: "%.3f")  Y: \(latestData.normalizedQuaternionY, specifier: "%.3f")  Z: \(latestData.normalizedQuaternionZ, specifier: "%.3f")")
                        .font(.caption2)
                        .fontDesign(.monospaced)
                }
                .padding([.horizontal, .bottom])
            }

            // debugging ble connection
            VStack(alignment: .leading) {
                let avg = sensorDataBuffer.packetsPerSecondHistory.reduce(0, +) / max(1, sensorDataBuffer.packetsPerSecondHistory.count)
                Text("Packets/sec: \(sensorDataBuffer.packetsPerSecond)  (\(Constants.ppsHistoryWindow)s avg: \(avg))")
                    .font(.caption2)
                Chart(Array(sensorDataBuffer.packetsPerSecondHistory.enumerated()), id: \.offset) { index, value in
                    LineMark(x: .value("Time", index), y: .value("PPS", value))
                }
                .frame(height: 60)
                .chartXScale(domain: 0...Constants.ppsHistoryWindow)
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        AxisValueLabel()
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    }
                }
            }
            .padding(.horizontal)
        }

        if axis == .horizontal {
            HStack { content }
        } else {
            VStack { content }
        }
        }
    }
}

struct DeviceDetailsModal: View {
    let device: Device
    let onDismiss: () -> Void

    @Environment(BluetoothManager.self) private var bluetoothManager

    var discoveredDevice: DiscoveredDevice? {
        bluetoothManager.getDiscoveredDevice(for: device.id)
    }

    var body: some View {
        Modal(onDismiss: onDismiss) {
            VStack {
                Text(device.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()

                VStack(alignment: .leading) {
                    Text("BLE ID: ").font(.headline) + Text("\(device.bluetoothId)")
                    (Text("Device ID: ").font(.headline) + Text("\(device.id)"))
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text("Paired On: ").font(.headline) + Text("\(device.pairedAt.formatted(date: .abbreviated, time: .shortened))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)

                if let discoveredDevice = discoveredDevice {
                    VStack(alignment: .leading) {
                        Text("Signal Strength: ").font(.headline) + Text("\(discoveredDevice.rssi) dBm")
                        Text("Battery Level: ").font(.headline) + Text("\(discoveredDevice.batteryLevel)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom)

                    DeviceSensorSection(sensorDataBuffer: discoveredDevice.sensorDataBuffer)
                } else {
                    Text("Device is offline")
                        .foregroundStyle(.secondary)
                        .padding()
                }

                HStack {
                    Button("Close") {
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)

                    Spacer()
                }
                .padding()
            }
        }
    }
}
