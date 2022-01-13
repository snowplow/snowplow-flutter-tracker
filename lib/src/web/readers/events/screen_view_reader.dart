import 'package:snowplow_flutter_tracker/events/screen_view.dart';
import 'event_reader.dart';

class ScreenViewReader extends ScreenView implements EventReader {
  ScreenViewReader(dynamic map)
      : super(
            name: map['name'],
            id: map['id'],
            type: map['type'],
            previousName: map['previousName'],
            previousType: map['previousType'],
            previousId: map['previousId'],
            transitionType: map['transitionType']);

  @override
  String endpoint() {
    return 'trackSelfDescribingEvent';
  }

  @override
  Map eventData() {
    var data = {
      'name': name,
      'id': id,
      'type': type,
      'previousName': previousName,
      'previousId': previousId,
      'previousType': previousType,
      'transitionType': transitionType
    };
    data.removeWhere((key, value) => value == null);
    return {
      'event': {
        'schema':
            'iglu:com.snowplowanalytics.mobile/screen_view/jsonschema/1-0-0',
        'data': data
      }
    };
  }
}
