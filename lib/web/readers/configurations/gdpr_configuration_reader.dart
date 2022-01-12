import 'package:snowplow_flutter_tracker/configurations/gdpr_configuration.dart';

class GdprConfigurationReader extends GdprConfiguration {
  GdprConfigurationReader(dynamic map)
      : super(
            basisForProcessing: map['basisForProcessing'],
            documentId: map['documentId'],
            documentVersion: map['documentVersion'],
            documentDescription: map['documentDescription']);
}
