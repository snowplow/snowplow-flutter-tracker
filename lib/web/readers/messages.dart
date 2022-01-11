import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/web/readers/events.dart';

@immutable
class EventMessageReader {
  final String tracker;
  final StructuredReader? structured;
  final SelfDescribingReader? selfDescribing;
  final ScreenViewReader? screenView;
  final TimingReader? timing;
  final ConsentGrantedReader? consentGranted;
  final ConsentWithdrawnReader? consentWithdrawn;

  const EventMessageReader(
      {required this.tracker,
      this.structured,
      this.selfDescribing,
      this.screenView,
      this.timing,
      this.consentGranted,
      this.consentWithdrawn});

  EventMessageReader.withStructured(dynamic map)
      : tracker = map['tracker'],
        structured = StructuredReader(map['eventData']),
        selfDescribing = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.withSelfDescribing(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = SelfDescribingReader(map['eventData']),
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.withScreenView(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = ScreenViewReader(map['eventData']),
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.withTiming(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = TimingReader(map['eventData']),
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.withConsentGranted(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = ConsentGrantedReader(map['eventData']),
        consentWithdrawn = null;

  EventMessageReader.withConsentWithdrawn(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = ConsentWithdrawnReader(map['eventData']);
}

@immutable
class SetUserIdMessageReader {
  final String tracker;
  final String? userId;

  SetUserIdMessageReader(dynamic map)
      : tracker = map['tracker'],
        userId = map['userId'];
}
