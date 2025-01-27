import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredPeripherals: [CBPeripheral] = []
    var centralManager: CBCentralManager?
    var scanTimer: Timer?
    var ad_string: String = ""
    
    // Reference vector
    var nz = Vector3D(x: 0, y: 0, z: 1)
    var ny = Vector3D(x: 0, y: 1, z: 0)
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Check Bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    // Start scanning for devices
    func startScanning() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
        // Set a 3-second timeout to stop scanning
        if scanTimer != nil {
            scanTimer?.invalidate()
        }
        scanTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(stopScanning), userInfo: nil, repeats: false)
    }
    
    // Stop scanning after a certain time (3 seconds)
    @objc func stopScanning() {
        centralManager?.stopScan()
        print("Scanning stopped.")
        
        // Handle the case where no devices were found
        if discoveredPeripherals.isEmpty {
            print("No peripherals found.")
        }
    }
    
    func getBattery(batt_level: Int) -> Int{
        return batt_level * 10 + 2000
    }
    
    
    // Get battery level, muscle level, spectrum, pitch, roll, yaw
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        if peripheral.name == "uMyo v2" {
            // Need conversion here because the data we get right now is
            // Data object rather than string. Also, remember to hex()
            if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
                let hexString = manufacturerData.map { String(format: "%02x", $0) }.joined(separator: " ")
                // Right now, hexArray is array of numbers
                let hexArray = hexString.split(separator: " ").compactMap { Int($0, radix: 16) }
                
                // Battery level
                let battery_level = getBattery(batt_level: hexArray[1])
                print(battery_level)
                
                // Get muscle level
                var sp1: Int16 = Int16((Int(hexArray[4]) << 8) | Int(hexArray[5]))
                var sp2: Int16 = Int16((Int(hexArray[6]) << 8) | Int(hexArray[7]))
                // sp3 maybe used later
                var sp3: Int16 = Int16((Int(hexArray[8]) << 8) | Int(hexArray[9]))
                // Be careful about the bit transfer
                var qw = Int32((Int(hexArray[10]) << 8) | Int(hexArray[11]))
                var muscle_lvl = sp1 + 2 * sp2
                print(muscle_lvl)
                
                // Get spectrum, we have four
                // Spectrum[0] = sp0, sp0 is hexArray[2]
                // Spectrum[1] = sp1 ... and so on
                
                // Get pitch
                var nzg = nz
                var Qgs = Quaternion(
                    x: Float(-hexArray[12]),
                    y: Float(-hexArray[13]),
                    z: Float(-hexArray[14]),
                    w: Float(qw)
                )
                Qgs = Qgs.normalized()
                nzg = Qgs.rotate(nzg)
                var pitch = acos_f(v_dot(nzg, ny))
                print(pitch)
                
                // Get Roll
                var nzg_roll = nz
                var Qgs_roll = Quaternion(
                    x: Float(-hexArray[12]),
                    y: Float(-hexArray[13]),
                    z: Float(-hexArray[14]),
                    w: Float(qw)
                )
                Qgs_roll = Qgs_roll.normalized()
                nzg_roll = Qgs_roll.rotate(nzg_roll)
                var roll = atan2_f(nzg_roll.z, nzg_roll.x)
                print(roll)
                
                // Get Yaw
                var nyr = ny
                nyr = Qgs.rotate(nyr)
                var yaw = atan2_f(nyr.x, nyr.z)
                print(yaw)
                
            }
            discoveredPeripherals.append(peripheral)
        }
    }
}


