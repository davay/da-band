import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager?
    var uMyoV2Peripheral: CBPeripheral?
    var scanTimer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // 1. Start scanning for peripherals, with a 3-second timeout
    func startScanning() {
        if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
            // Set a 3-second timer to stop scanning
            if scanTimer != nil {
                scanTimer?.invalidate()
            }
            scanTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(stopScanning), userInfo: nil, repeats: false)
        }
    }
    
    // Make sure bluetooth is on
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        if peripheral.name == "uMyo v2" {
            uMyoV2Peripheral = peripheral
            stopScanning()
            
            // Ready to apply mathematical functions to the data from uMyo v2
            // Add your math function logic here
        }
    }
    
    @objc func stopScanning() {
        centralManager?.stopScan()
        
        if uMyoV2Peripheral == nil {
            // Handle case where 'uMyo v2' was not found (e.g., retry, continue silently, etc.)
        }
        
        scanTimer?.invalidate()
        scanTimer = nil
    }
}
