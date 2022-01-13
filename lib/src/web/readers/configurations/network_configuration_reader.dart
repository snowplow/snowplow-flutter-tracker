import 'package:snowplow_flutter_tracker/configurations/network_configuration.dart';

class NetworkConfigurationReader extends NetworkConfiguration {
  NetworkConfigurationReader(dynamic map)
      : super(endpoint: map['endpoint'], method: map['method']);

  void addTrackerOptions(dynamic options) {
    if (method != null) {
      options['eventMethod'] = method;
    }
  }
}
