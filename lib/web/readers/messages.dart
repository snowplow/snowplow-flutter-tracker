import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/events.dart';

@immutable
class EventMessageReader {
  final String tracker;
  final Structured? structured;
  final SelfDescribing? selfDescribing;
  final ScreenView? screenView;
  final Timing? timing;
  final ConsentGranted? consentGranted;
  final ConsentWithdrawn? consentWithdrawn;

  const EventMessageReader(
      {required this.tracker,
      this.structured,
      this.selfDescribing,
      this.screenView,
      this.timing,
      this.consentGranted,
      this.consentWithdrawn});

  EventMessageReader.fromMapStructured(dynamic map)
      : tracker = map['tracker'],
        structured = Structured.fromMap(map['eventData']),
        selfDescribing = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.fromMapSelfDescribing(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = SelfDescribing.fromMap(map['eventData']),
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.fromMapScreenView(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = ScreenView.fromMap(map['eventData']),
        timing = null,
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.fromMapTiming(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = Timing.fromMap(map['eventData']),
        consentGranted = null,
        consentWithdrawn = null;

  EventMessageReader.fromMapConsentGranted(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = ConsentGranted.fromMap(map['eventData']),
        consentWithdrawn = null;

  EventMessageReader.fromMapConsentWithdrawn(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = ConsentWithdrawn.fromMap(map['eventData']);
}
