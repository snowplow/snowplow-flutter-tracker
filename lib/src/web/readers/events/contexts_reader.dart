import 'package:flutter/foundation.dart';
import 'self_describing_reader.dart';

@immutable
class ContextsReader {
  final Iterable<SelfDescribingReader> selfDescribingJsons;

  ContextsReader(List jsons)
      : selfDescribingJsons =
            jsons.map((x) => SelfDescribingReader(x)).toList();
}
