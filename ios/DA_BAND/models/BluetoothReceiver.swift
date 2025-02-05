import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    
    struct DetectedSignal: Codable {
        let serialNumber: String
        let batteryLevel: Int
        let muscleLevel: Int16
        let pitch: Float
        let roll: Float
        let yaw: Float
    }
    
    @Published var detectedSignals: [DetectedSignal]
    var centralManager: CBCentralManager?
    var scanTimer: Timer?
    var nz = Vector3D(x: 0, y: 0, z: 1)
    var ny = Vector3D(x: 0, y: 1, z: 0)
    
    var dataUpdateHandler: ((String, Int, Int16, Float, Float, Float) -> Void)?
    
    override init() {
        self.detectedSignals = []
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .background))
    }
    
    func startScanning() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        scanTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(stopScanning), userInfo: nil, repeats: false)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Give extra time to fully start up, not sure the specific time yet
            print("Powered on. Ready to scan.")
        case .poweredOff:
            print("Bluetooth OFF. Please enable it.")
        default:
            print("Wth happened?")
        }
    }
    
    func getBattery(batt_level: Int) -> Int {
        return batt_level * 10 + 2000
    }
    
    @objc func stopScanning() {
        centralManager?.stopScan()
        print(detectedSignals)
        
        guard let url = URL(string: "https://webhook.site/47a66e7c-6d72-484a-8304-a71d90cd1287") else {
            print("Invalid URL")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(detectedSignals)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Request failed with error: \(error)")
                    return
                }
            }
            task.resume()
        } catch {
            print("Failed to encode to JSON: \(error)")
        }
    }

    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi: NSNumber
    ) {
        guard let name = peripheral.name, name == "uMyo v2" else { return }
        
        let serialNumber = peripheral.identifier.uuidString
        print("[Bluetooth] Discovered uMyo v2 (Serial: \(serialNumber))")
        
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            let hexArray = manufacturerData.map { Int($0) }
            
            let battery_level = getBattery(batt_level: hexArray[1])
            
            let sp1 = Int16((hexArray[4] << 8) | hexArray[5])
            let sp2 = Int16((hexArray[6] << 8) | hexArray[7])
            let muscle_level = sp1 + 2 * sp2
            
            let qw = Int32((hexArray[10] << 8) | hexArray[11])
            var Qgs = Quaternion(
                x: Float(-hexArray[12]),
                y: Float(-hexArray[13]),
                z: Float(-hexArray[14]),
                w: Float(qw)
            ).normalized()
            
            let pitch = acos_f(v_dot(Qgs.rotate(nz), ny))
            let roll = atan2_f(Qgs.rotate(nz).z, Qgs.rotate(nz).x)
            let yaw = atan2_f(Qgs.rotate(ny).x, Qgs.rotate(ny).z)
            let signal = DetectedSignal(
                serialNumber: serialNumber,
                batteryLevel: battery_level,
                muscleLevel: muscle_level,
                pitch: pitch,
                roll: roll,
                yaw: yaw
            )
            
            DispatchQueue.main.async {
                self.detectedSignals.append(signal)
                }
            }
        }
    }
