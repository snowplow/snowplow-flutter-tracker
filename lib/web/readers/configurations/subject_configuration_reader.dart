import 'package:snowplow_flutter_tracker/configurations/subject_configuration.dart';

class SubjectConfigurationReader extends SubjectConfiguration {
  SubjectConfigurationReader(dynamic map)
      : super(
            userId: map['userId'],
            networkUserId: map['networkUserId'],
            domainUserId: map['domainUserId'],
            userAgent: map['userAgent'],
            ipAddress: map['ipAddress'],
            timezone: map['timezone'],
            language: map['language'],
            colorDepth: map['colorDepth']);
}
