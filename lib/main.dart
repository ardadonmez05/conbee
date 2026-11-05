import 'package:flutter/material.dart';

import 'models/smart_device.dart';

void main() => runApp(const SmartHomeApp());

const purple = Color(0xFF8270AD);
const ink = Color(0xFF302B3B);

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'conbee.',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purple,
        primary: purple,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F7FA),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: ink)),
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<SmartDevice> devices = [
    SmartLight('Main light', 'Living room'),
    Thermostat('Thermostat', 'Living room'),
    SmartSpeaker('Home speaker', 'Living room'),
    SmartLight.bedside(),
  ];
  String selectedRoom = 'All rooms';

  @override
  Widget build(BuildContext context) {
    final visible = devices
        .where((d) => selectedRoom == 'All rooms' || d.room == selectedRoom)
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'c',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'conbee.',
                      style: TextStyle(
                        color: ink,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Your devices',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: ['All rooms', 'Living room', 'Bedroom']
                      .map(
                        (room) => ChoiceChip(
                          label: Text(room),
                          selected: selectedRoom == room,
                          showCheckmark: false,
                          onSelected: (_) =>
                              setState(() => selectedRoom = room),
                          selectedColor: const Color(0xFFECE7F4),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 600 ? 2 : 1;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: visible
                          .map(
                            (device) => SizedBox(
                              width:
                                  (constraints.maxWidth - (columns - 1) * 16) /
                                  columns,
                              child: deviceCard(device),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.devices_outlined,
                      size: 16,
                      color: Color(0xFF918A9B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${SmartDevice.totalDevices} devices created',
                      style: const TextStyle(
                        color: Color(0xFF918A9B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deviceCard(SmartDevice device) {
    final icon = device is SmartLight
        ? Icons.lightbulb_outline
        : device is Thermostat
        ? Icons.thermostat_outlined
        : Icons.speaker_outlined;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEBF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: purple),
              ),
              const Spacer(),
              if (device is SmartLight)
                Switch(
                  value: device.isOn,
                  onChanged: (_) => setState(device.toggle),
                )
              else
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF93AB98),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            device.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            '${device.room} · ${device.getStatus()}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF918A9B)),
          ),
          const SizedBox(height: 22),
          if (device is SmartLight) ...[
            valueLabel('Brightness', '${device.brightness.round()}%'),
            Slider(
              value: device.brightness,
              min: 0,
              max: 100,
              onChanged: device.isOn
                  ? (v) => setState(() => device.brightness = v)
                  : null,
            ),
            TextButton.icon(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 20, minute: 0),
                );
                if (time != null && mounted) {
                  setState(() => device.schedule(time.format(context)));
                }
              },
              icon: const Icon(Icons.schedule, size: 16),
              label: Text(
                device.scheduledTime == null
                    ? 'Set a reminder'
                    : 'Reminder at ${device.scheduledTime}',
              ),
            ),
            if (device.scheduledTime != null)
              TextButton(
                onPressed: () => setState(device.clearSchedule),
                child: const Text('Clear reminder'),
              ),
          ],
          if (device is Thermostat) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: device.temperature > 16
                      ? () => setState(() => device.adjust(-1))
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '${device.temperature}°',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -2,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: device.temperature < 30
                      ? () => setState(() => device.adjust(1))
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Target temperature · 16–30°C',
                style: TextStyle(fontSize: 12, color: Color(0xFF918A9B)),
              ),
            ),
          ],
          if (device is SmartSpeaker) ...[
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Playback',
                    style: TextStyle(color: Color(0xFF918A9B)),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => setState(device.togglePlayback),
                  tooltip: device.isPlaying ? 'Pause' : 'Play',
                  icon: Icon(
                    device.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            valueLabel('Volume', '${device.volume.round()}%'),
            Slider(
              value: device.volume,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => device.volume = v),
            ),
          ],
        ],
      ),
    );
  }

  Widget valueLabel(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(color: Color(0xFF918A9B), fontSize: 12),
      ),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    ],
  );
}
