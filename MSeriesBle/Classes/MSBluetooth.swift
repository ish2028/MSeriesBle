//
//  MSBluetooth.swift
//  MSeries
//
//  Created by Ismael Huerta on 12/9/16.
//  Copyright © 2016 Ismael Huerta. All rights reserved.
//

import UIKit
import CoreBluetooth

public class MSBluetooth: NSObject, CBCentralManagerDelegate {
    
    private var bleCentralManager: CBCentralManager!;
    private var cleanUpTimer: Timer?
    private var cycleTimer: Timer?
    public var focusedBikeId: Int?
    
    public var discoveredBikes = [(machineBroadcast: MSBLEMachineBroadcast, lastReceivedTime: Date)]() {
        didSet {
            let notification = Notification(name: NSNotification.Name(rawValue: BluetoothConnectionNotifications.BluetoothConnectionUpdateDiscoveredMachines), object: self)
            NotificationCenter.default.post(notification)
            
        }
    }
    
    public struct BluetoothConnectionNotifications {
        static public let BluetoothConnectionDidDiscoverMachine = "DiscoveredMachine"
        static public let BluetoothConnectionDidReceiveMachineBroadcast = "ReceivedMachineBroadcast"
        static public let BluetoothConnectionUpdateDiscoveredMachines = "UpdatedDiscoveredMachine"
    }
    
    static public let sharedInstance: MSBluetooth = {
        let instance = MSBluetooth()
        return instance
    }()
    
    override init() {
        super.init()
        bleCentralManager = CBCentralManager.init(delegate: self, queue: nil)
    }
    
    func cleanUpDiscoveredBikes() {
        let machinesAvailable = discoveredBikes.filter({$0.lastReceivedTime.timeIntervalSinceNow >= -60})
        if (!machinesAvailable.elementsEqual(discoveredBikes, by: { (available, discovered) -> Bool in
            return available == discovered
        })) {
            discoveredBikes = machinesAvailable
        }
    }
    
    private func startScanning() {
        cycle()
        cleanUpTimer = Timer(timeInterval: 60, target: self, selector: #selector(cleanUpDiscoveredBikes), userInfo: nil, repeats: true)
        RunLoop.current.add(cleanUpTimer!, forMode: .defaultRunLoopMode)
    }
    
    private func cycle() {
        if bleCentralManager.isScanning {
            bleCentralManager.stopScan()
        }
        bleCentralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    }
    
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn: startScanning()
        case .unsupported: break // TODO: send notification to controller that bluetooth is not enabled.
        case .unauthorized: break // TODO: send notification to controller that bluetooth is not authorized
        case .poweredOff: break // TODO: send notification to controller that power is off
        default: break
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            if (peripheral.name?.compare("M3") != ComparisonResult.orderedSame){
                return;
            }
            let machineBroadcast = MSBLEMachineBroadcast(manufactureData: advertisementData[CBAdvertisementDataManufacturerDataKey] as! Data)
            machineBroadcast.name = peripheral.name!
            machineBroadcast.address = peripheral.identifier.uuidString            
            if (machineBroadcast.isValid){
                if (focusedBikeId != nil && machineBroadcast.machineID == focusedBikeId!){
                    let notification = Notification(name: Notification.Name(BluetoothConnectionNotifications.BluetoothConnectionDidReceiveMachineBroadcast), object: self, userInfo: ["broadcast" : machineBroadcast])
                    NotificationCenter.default.post(notification)
                    return;
                }
                var found = false
                for i in 0..<discoveredBikes.count {
                    var discoveredBikeTuple = discoveredBikes[i]
                    if discoveredBikeTuple.machineBroadcast.machineID == machineBroadcast.machineID {
                        found = true
                        discoveredBikeTuple.lastReceivedTime = Date()
                        discoveredBikes[i] = discoveredBikeTuple
                    }
                }
                if !found {
                    discoveredBikes.append((machineBroadcast, Date()))
                    let notification = Notification(name: Notification.Name(BluetoothConnectionNotifications.BluetoothConnectionDidDiscoverMachine), object: self, userInfo: ["broadcast" : machineBroadcast])
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }

}
