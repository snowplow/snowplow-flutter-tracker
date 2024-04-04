import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SnowplowBDP extends StatelessWidget {
  const SnowplowBDP({super.key});

  @override
  Widget build(BuildContext context) {
    return const Markdown(
      data:
          '''# Snowplow BDP: the behavioral data platform that drives more value, faster
      
Behavioral data is generated in / collected from different digital touchpoints, typically including websites and mobile apps (referred to as "Sources"). Sources can include third party SaaS solutions that support webhooks (e.g. Zendesk, Mailgun). 

Snowplow BDP processes and delivers this behavioral data to different endpoints (referred to as "Destinations"). From there, companies use that data to accomplish different use cases. Destinations include data warehouses (AWS Redshift, GCP BigQuery, SnowflakeDB), data lakes (AWS S3, GCP GCS) and streams (e.g. AWS Kinesis, GCP Pub/Sub).

As part of Snowplow BDP we provide standard models (e.g. web or mobile models) that transform the data in the data warehouse to make it easier to consume by downstream applications and systems (e.g. business intelligence).

Key features
------------

### Data processing-as-a-Service

Snowplow BDP is provided as a service. Snowplow takes responsibility for the setup, administration and successful running of the Snowplow behavioral data pipeline(s) and all related technology infrastructure. 

Please note that the Snowplow team can only do the above subject to the customer providing Snowplow with the required access levels to their cloud infrastructure, and compliance with all Snowplow Documentation and reasonable instructions.

### A UI and API are provided to facilitate pipeline management and monitoring

Snowplow BDP customers can manage the setup and configuration of their Snowplow pipeline via a UI and API on console.snowplowanalytics.com. This provides functionality to:

-   View and update pipeline configuration, including testing changes in a development environment before pushing them to production2
-   Manage and evolve event and entity definitions
-   Monitor and enhance data quality

### Open core

The core data processing elements of the Snowplow pipeline are predominantly open source and the code is available on GitHub under the Apache 2 license.

Key elements of the Snowplow BDP technology stack, including the UI and API, are proprietary.

### Data residency

All data processed and collected with Snowplow BDP is undertaken within the customer's own cloud account (e.g. AWS, GCP). The customer decides:

-   What data is collected
-   Where it is processed and stored (e.g. what cloud and region)
-   What the data is used for and who has access to it

It is the customer's obligation (and not Snowplow's) to maintain and administer the cloud account.  Each of customer's and Snowplow's obligations with respect to data protection and privacy are set forth in a Data Protection Agreement.
''',
    );
  }
}
