import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/web/readers/events/self_describing_reader.dart';

@immutable
class ContextsReader {
  final Iterable<SelfDescribingReader> selfDescribingJsons;

  ContextsReader(List jsons)
      : selfDescribingJsons =
            jsons.map((x) => SelfDescribingReader(x)).toList();
}
