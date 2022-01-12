import 'package:snowplow_flutter_tracker/events/structured.dart';
import 'package:snowplow_flutter_tracker/web/readers/events/event_reader.dart';

class StructuredReader extends Structured implements EventReader {
  StructuredReader(dynamic map)
      : super(
            category: map['category'],
            action: map['action'],
            label: map['label'],
            property: map['property'],
            value: map['value']);

  @override
  String endpoint() {
    return 'trackStructEvent';
  }

  @override
  Map eventData() {
    final data = {
      'category': category,
      'action': action,
      'label': label,
      'property': property,
      'value': value
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
