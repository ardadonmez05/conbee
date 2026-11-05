# conbee. - Smart Home Controller

Flutter app with white and muted purple styling, Material icons, responsive cards, and room filters. Device controls simulate local state without hardware.

Run `flutter pub get`, then `flutter run` (or `flutter run -d chrome`).
Validate with `flutter analyze` and `flutter test`.

The models in lib/models/smart_device.dart demonstrate an abstract base class, three subclasses, Connectable interface, Schedulable mixin, default and named constructors, static, super, and this. The footer uses the static device count.

Lights have power and brightness controls; the thermostat supports 16-30 degrees; the speaker has playback and volume. Light reminders only record a selected time and do not send notifications. State resets on restart.

Harun Behlül Pınarlı - 37651350482
Arda Dönmez - 10910549032
