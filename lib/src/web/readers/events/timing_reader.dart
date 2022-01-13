import 'package:snowplow_flutter_tracker/events/timing.dart';
import 'event_reader.dart';

class TimingReader extends Timing implements EventReader {
  TimingReader(dynamic map)
      : super(
            category: map['category'],
            variable: map['variable'],
            timing: map['timing'],
            label: map['label']);

  @override
  String endpoint() {
    return 'trackTiming';
  }

  @override
  Map eventData() {
    return {
      'category': category,
      'variable': variable,
      'timing': timing,
      'label': label,
    };
  }
}
