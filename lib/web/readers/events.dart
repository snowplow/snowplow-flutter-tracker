import 'package:snowplow_flutter_tracker/events.dart';
import 'package:flutter/foundation.dart';

abstract class EventReader {
  String endpoint();
  Map eventData();
}

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

class ConsentGrantedReader extends ConsentGranted implements EventReader {
  ConsentGrantedReader(dynamic map)
      : super(
            expiry: map['expiry'],
            documentId: map['documentId'],
            version: map['version'],
            name: map['name'],
            documentDescription: map['documentDescription']);

  @override
  String endpoint() {
    return 'trackConsentGranted';
  }

  @override
  Map eventData() {
    return {
      'id': documentId,
      'version': version,
      'name': name,
      'description': documentDescription,
      'expiry': expiry
    };
  }
}

class ConsentWithdrawnReader extends ConsentWithdrawn implements EventReader {
  ConsentWithdrawnReader(dynamic map)
      : super(
            all: map['all'],
            documentId: map['documentId'],
            version: map['version'],
            name: map['name'],
            documentDescription: map['documentDescription']);

  @override
  String endpoint() {
    return 'trackConsentWithdrawn';
  }

  @override
  Map eventData() {
    return {
      'all': all,
      'id': documentId,
      'version': version,
      'name': name,
      'description': documentDescription
    };
  }
}

@immutable
class ContextsReader {
  final Iterable<SelfDescribingReader> selfDescribingJsons;

  ContextsReader(List jsons)
      : selfDescribingJsons =
            jsons.map((x) => SelfDescribingReader(x)).toList();
}
