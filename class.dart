abstract class Switchable {
  void turnOn();
  void turnOff();
}

abstract class Adjustable {
  void increase();
  void decrease();
}

mixin BatteryPowered {
  int batteryLevel = 100;
  void showBattery() {
    print('Battery level: $batteryLevel%');
  }
}

abstract class Device implements Switchable {
  final String name;
  Device(this.name);
  void showInfo() {
    print('Device: $name');
  }
}

class SmartLamp extends Device with BatteryPowered implements Adjustable {
  int brightness = 50;

  SmartLamp(String name) : super(name);

  @override
  void turnOn() {
    print('Lamp $name is ON');
  }

  @override
  void turnOff() {
    print('Lamp $name is OFF');
  }

  @override
  void increase() {
    brightness += 10;
    if (brightness > 100) brightness = 100;
  }

  @override
  void decrease() {
    brightness -= 10;
    if (brightness < 0) brightness = 0;
  }

  @override
  void showInfo() {
    print('Device: $name, Brightness: $brightness%');
  }
}

class SmartSpeaker extends Device with BatteryPowered implements Adjustable {
  int volume = 30;

  SmartSpeaker(String name) : super(name);

  @override
  void turnOn() {
    print('Speaker $name is ON');
  }

  @override
  void turnOff() {
    print('Speaker $name is OFF');
  }

  @override
  void increase() {
    volume += 5;
    if (volume > 100) volume = 100;
  }

  @override
  void decrease() {
    volume -= 5;
    if (volume < 0) volume = 0;
  }

  @override
  void showInfo() {
    print('Device: $name, Volume: $volume%');
  }
}
