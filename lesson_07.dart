import 'class.dart';

void main() {
  List<Device> devices = [
    SmartLamp('Living Room Lamp'),
    SmartSpeaker('Kitchen Speaker'),
  ];

  for (var device in devices) {
    device.showInfo();
    device.turnOn();
    
    if (device is Adjustable) {
      (device as Adjustable).increase();
    }
    
    if (device is BatteryPowered) {
      (device as BatteryPowered).showBattery();
    }
  }

  print('All devices processed.');
}
