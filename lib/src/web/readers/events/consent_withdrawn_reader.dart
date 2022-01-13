import 'event_reader.dart';
import 'package:snowplow_flutter_tracker/events/consent_withdrawn.dart';

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
