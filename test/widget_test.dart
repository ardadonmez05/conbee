import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/smart_device.dart';

void main() {
  test('Device controls and static count', () {
    final before = SmartDevice.totalDevices;
    final light = SmartLight.bedside();
    final thermostat = Thermostat('Climate', 'Living room');
    final speaker = SmartSpeaker('Speaker', 'Living room');
    expect(SmartDevice.totalDevices, before + 3);
    light.toggle();
    expect(light.isOn, isTrue);
    light.schedule('20:00');
    expect(light.scheduledTime, '20:00');
    thermostat.adjust(100);
    expect(thermostat.temperature, 30);
    thermostat.adjust(-100);
    expect(thermostat.temperature, 16);
    speaker.togglePlayback();
    expect(speaker.getStatus(), 'Playing');
  });
  testWidgets('Room filter and light switch', (tester) async {
    SmartDevice.totalDevices = 0;
    await tester.pumpWidget(const SmartHomeApp());
    expect(find.text('Main light'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(find.text('Living room · Off'), findsOneWidget);
    await tester.tap(find.text('Bedroom'));
    await tester.pumpAndSettle();
    expect(find.text('Bedside light'), findsOneWidget);
    expect(find.text('Main light'), findsNothing);
  });
}
