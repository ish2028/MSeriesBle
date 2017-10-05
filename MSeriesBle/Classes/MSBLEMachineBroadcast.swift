//
//  MSBLEMachineBroadcast.swift
//  MSeries
//
//  Created by Ismael Huerta on 9/9/16.
//  Copyright © 2016 Ismael Huerta. All rights reserved.
//

import Foundation

public class MSBLEMachineBroadcast: NSObject {
    public var name = "";
    public var address = "";
    public var isRealTime = false
    public var receivedTime = Date()
    public var machineID: Int = 0
    public var buildMajor: Int?
    public var buildMinor: Int?
    public var dataType: Int?
    public var interval: Int?
    public var rpm: Int?
    public var heartRate: Int?
    public var power: Int?
    public var kCal: Int?
    public var time: TimeInterval?
    public var trip: Double?
    public var gear: Int?
    
    public init(manufactureData: Data) {
        var data = manufactureData
        if (data.count > 17){
            data = data.subdata(in: Range(uncheckedBounds: (lower: 2, upper: data.count)))
        }
        var tempTrip: Int32?
        for (index, byte) in data.enumerated(){
            switch index {
            case 0: buildMajor = Int(byte)
            case 1: buildMinor = Int(byte)
            case 2: dataType = Int(byte);
            case 3: machineID = Int(byte)
            case 4: rpm = Int(byte)
            case 5: rpm = Int(UInt16(byte) << 8 | UInt16(rpm!))
            case 6: heartRate = Int(byte)
            case 7: heartRate = Int(UInt16(byte) << 8 | UInt16(heartRate!))
            case 8: power = Int(byte)
            case 9: power = Int(UInt16(byte) << 8 | UInt16(power!))
            case 10: kCal = Int(byte)
            case 11: kCal = Int(UInt16(byte) << 8 | UInt16(kCal!))
            case 12: time = Double(byte) * 60
            case 13: time = time! + Double(byte)
            case 14: tempTrip = Int32(byte)
            case 15: tempTrip = Int32(UInt16(byte) << 8 | UInt16(tempTrip!))
            case 16: gear = Int(byte)
            default: break
                
            }
        }
        rpm = rpm!/10
        heartRate = heartRate!/10
        super.init()
        if (dataType == 0 || dataType == 255) {
            interval = 0
        }
        else if (dataType! > 128 && dataType! < 255) {
            interval = dataType! - 128
        }
        isRealTime = dataType! < 255
        if tempTrip! & 32768 != 0 {
            trip = (Double(tempTrip! & 32767) * 0.62137119) / 10.0
        }
        else {
            trip = Double(tempTrip!) / 10.0
        }
    }
    
    public var scanResult: String {
        get {
            return "scanResult"
        }
    }
    
    public var isValid: Bool {
        get {
            return name.characters.count > 0 && machineID > 0
        }
    }
}
