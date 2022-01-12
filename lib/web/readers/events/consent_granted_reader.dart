import 'package:snowplow_flutter_tracker/events/consent_granted.dart';
import 'package:snowplow_flutter_tracker/web/readers/events/event_reader.dart';

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
