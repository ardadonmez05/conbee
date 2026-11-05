abstract interface class Connectable {
  void connect();
  void disconnect();
}

mixin Schedulable {
  String? scheduledTime;
  void schedule(String time) => scheduledTime = time;
  void clearSchedule() => scheduledTime = null;
}

abstract class SmartDevice implements Connectable {
  static int totalDevices = 0;
  final String name;
  final String room;
  bool isConnected = true;

  SmartDevice(this.name, this.room) {
    totalDevices++;
  }

  @override
  void connect() => isConnected = true;
  @override
  void disconnect() => isConnected = false;
  String getStatus();
}

class SmartLight extends SmartDevice with Schedulable {
  bool isOn;
  double brightness;
  SmartLight(super.name, super.room, {this.isOn = true, this.brightness = 70});
  SmartLight.bedside()
    : this('Bedside light', 'Bedroom', isOn: false, brightness: 40);
  void toggle() => isOn = !isOn;
  @override
  String getStatus() => isOn ? 'On' : 'Off';
}

class Thermostat extends SmartDevice {
  int temperature;
  Thermostat(super.name, super.room, {this.temperature = 22});
  void adjust(int delta) => temperature = (temperature + delta).clamp(16, 30);
  @override
  String getStatus() => 'Heating · Auto';
}

class SmartSpeaker extends SmartDevice {
  bool isPlaying = false;
  double volume;
  SmartSpeaker(super.name, super.room, {this.volume = 45});
  void togglePlayback() => isPlaying = !isPlaying;
  @override
  String getStatus() => isPlaying ? 'Playing' : 'Paused';
}
