import 'package:flutter/foundation.dart';

@immutable
abstract class Event {
  String endpoint();
  Map<String, Object?> toMap();
}

@immutable
class Structured implements Event {
  final String category;
  final String action;
  final String? label;
  final String? property;
  final double? value;

  const Structured(
      {required this.category,
      required this.action,
      this.label,
      this.property,
      this.value});

  @override
  String endpoint() {
    return 'trackStructured';
  }

  Structured.fromMap(dynamic map)
      : category = map['category'],
        action = map['action'],
        label = map['label'],
        property = map['property'],
        value = map['value'];

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'category': category,
      'action': action,
      'label': label,
      'property': property,
      'value': value,
    };
  }
}

@immutable
class SelfDescribing implements Event {
  final String schema;
  final Map<String, Object?> data;

  const SelfDescribing({required this.schema, required this.data});

  @override
  String endpoint() {
    return 'trackSelfDescribing';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'schema': schema,
      'data': data,
    };
  }
}

@immutable
class ScreenView implements Event {
  final String name;
  final String? id;
  final String? type;
  final String? previousName;
  final String? previousType;
  final String? previousId;
  final String? transitionType;

  const ScreenView(
      {required this.name,
      this.id,
      this.type,
      this.previousName,
      this.previousType,
      this.previousId,
      this.transitionType});

  @override
  String endpoint() {
    return 'trackScreenView';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'name': name,
      'id': id,
      'type': type,
      'previousName': previousName,
      'previousType': previousType,
      'previousId': previousId,
      'transitionType': transitionType,
    };
  }
}

@immutable
class Timing implements Event {
  final String category;
  final String variable;
  final int timing;
  final String? label;

  const Timing(
      {required this.category,
      required this.variable,
      required this.timing,
      this.label});

  @override
  String endpoint() {
    return 'trackTiming';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'category': category,
      'variable': variable,
      'timing': timing,
      'label': label,
    };
  }
}

@immutable
class ConsentGranted implements Event {
  final String expiry;
  final String documentId;
  final String version;
  final String? name;
  final String? documentDescription;
  final List<ConsentDocument>? consentDocuments;

  const ConsentGranted(
      {required this.expiry,
      required this.documentId,
      required this.version,
      this.name,
      this.documentDescription,
      this.consentDocuments});

  @override
  String endpoint() {
    return 'trackConsentGranted';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'expiry': expiry,
      'documentId': documentId,
      'version': version,
      'name': name,
      'documentDescription': documentDescription,
      'consentDocuments': consentDocuments?.map((d) => d.toMap()).toList()
    };
  }
}

@immutable
class ConsentWithdrawn implements Event {
  final bool all;
  final String documentId;
  final String version;
  final String? name;
  final String? documentDescription;
  final List<ConsentDocument>? consentDocuments;

  const ConsentWithdrawn(
      {required this.all,
      required this.documentId,
      required this.version,
      this.name,
      this.documentDescription,
      this.consentDocuments});

  @override
  String endpoint() {
    return 'trackConsentWithdrawn';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'all': all,
      'documentId': documentId,
      'version': version,
      'name': name,
      'documentDescription': documentDescription,
      'consentDocuments': consentDocuments?.map((d) => d.toMap()).toList()
    };
  }
}

@immutable
class ConsentDocument {
  final String documentId;
  final String documentVersion;
  final String? documentName;
  final String? documentDescription;

  const ConsentDocument(
      {required this.documentId,
      required this.documentVersion,
      this.documentName,
      this.documentDescription});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'documentId': documentId,
      'documentName': documentName,
      'documentVersion': documentVersion,
      'documentDescription': documentDescription,
    };
  }
}
