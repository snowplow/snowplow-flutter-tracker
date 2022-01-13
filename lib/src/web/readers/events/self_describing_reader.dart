import 'package:snowplow_flutter_tracker/events/self_describing.dart';
import 'event_reader.dart';

class SelfDescribingReader extends SelfDescribing implements EventReader {
  SelfDescribingReader(dynamic map)
      : super(schema: map['schema'], data: map['data']);

  @override
  String endpoint() {
    return 'trackSelfDescribingEvent';
  }

  Map json() {
    return {'schema': schema, 'data': data};
  }

  @override
  Map eventData() {
    return {'event': json()};
  }
}
