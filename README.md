# MSeriesBle

## Getting Started
This library uses notification dispatch mechanism to receive data.  Start by getting a shared instance of `MSBluetooth`. 

``` 
let bluetooth = MSBluetooth.sharedInstance
```

Scanning starts automatically, so call this as soon as possible to start listening for bikes.  `MSBluetooth` keeps track of discovered machines in a array of tuples `(machineBroadcast: MSBLEMachineBroadcast, lastReceviedTime: Date)`.  You can access this array using 
```
bluetooth.discoveredBikes
```

The notification object is an instance of `MSBluetooth` so that you can access any public varaibles you need.

### Discovering Machines
Notifies you when a new machine has been discovered.
```
NotificationCenter.default.addObserver(
            forName: NSNotification.Name(MSBluetooth.BluetoothConnectionNotifications.BluetoothConnectionDidDiscoverMachine ),
            object: bluetooth,
            queue: queue)
        { notification in
            self.discoveredMachine(notification: notification)
        }
```

### Updates from discovered machines
Notifies you when a machine is no longer transmitting data.
```
NotificationCenter.default.addObserver(
            forName: NSNotification.Name(MSBluetooth.BluetoothConnectionNotifications.BluetoothConnectionUpdateDiscoveredMachines ),
            object: bluetooth,
            queue: queue)
        { notification in
            self.discoveredMachine(notification: notification)
        }
```

### Listening to a specific bike
To list to a specific bike simply set the `focusedBikeId` on `MSBluetooth` and register to receive notifications using
```
NotificationCenter.default.addObserver(
            forName: NSNotification.Name(MSBluetooth.BluetoothConnectionNotifications.BluetoothConnectionDidReceiveMachineBroadcast),
            object: bluetooth,
            queue: queue)
        { notification in
            self.updateData(notification: notification)
        }
```

`notification.userInfor` contains a `broadcast` key that is an instance of `MSBLEMachineBroadcast`.  This object contains the parsed data from the bike.

## Installation

MSeriesBle is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MSeriesBle'
```

## Author

imartinez2028@gmail.com

## License

MSeriesBle is available under the MIT license. See the LICENSE file for more info.
