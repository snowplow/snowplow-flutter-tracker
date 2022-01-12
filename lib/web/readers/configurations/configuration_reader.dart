import 'package:snowplow_flutter_tracker/configurations/configuration.dart';
import 'package:snowplow_flutter_tracker/web/readers/configurations/gdpr_configuration_reader.dart';
import 'package:snowplow_flutter_tracker/web/readers/configurations/network_configuration_reader.dart';
import 'package:snowplow_flutter_tracker/web/readers/configurations/subject_configuration_reader.dart';
import 'package:snowplow_flutter_tracker/web/readers/configurations/tracker_configuration_reader.dart';

class ConfigurationReader extends Configuration {
  ConfigurationReader(dynamic map)
      : super(
            namespace: map['namespace'],
            networkConfig: NetworkConfigurationReader(map['networkConfig']),
            trackerConfig: map['trackerConfig'] != null
                ? TrackerConfigurationReader(map['trackerConfig'])
                : null,
            subjectConfig: map['subjectConfig'] != null
                ? SubjectConfigurationReader(map['subjectConfig'])
                : null,
            gdprConfig: map['gdprConfig'] != null
                ? GdprConfigurationReader(map['gdprConfig'])
                : null);

  dynamic getTrackerOptions() {
    var options = {};

    (networkConfig as NetworkConfigurationReader).addTrackerOptions(options);
    if (trackerConfig != null) {
      (trackerConfig as TrackerConfigurationReader).addTrackerOptions(options);
    }

    return options;
  }
}
