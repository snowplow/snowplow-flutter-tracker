import 'package:flutter/material.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:uuid/uuid.dart';
import 'overview.dart';
import 'snowplow_bdp.dart';

class NestedPage extends StatefulWidget {
  const NestedPage({required this.tracker, required this.observer, Key? key})
      : super(key: key);

  final Tracker tracker;
  final SnowplowObserver observer;

  static const String routeName = '/tab';

  @override
  State<StatefulWidget> createState() => _NestedPageState();
}

class _NestedPageState extends State<NestedPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    vsync: this,
    length: tabs.length,
    initialIndex: selectedIndex,
  );
  int selectedIndex = 0;

  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Flutter Tracker'),
    const Tab(text: 'Snowplow BDP'),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (selectedIndex != _controller.index) {
          selectedIndex = _controller.index;
          _trackCurrentTabChange();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: tabs.map((Tab tab) {
          return Center(
              child: tab.text == 'Snowplow BDP'
                  ? const SnowplowBDP()
                  : const Overview());
        }).toList(),
      ),
    );
  }

  void _trackCurrentTabChange() {
    final tabName = selectedIndex == 0 ? 'tracker' : 'bdp';
    final title = '${NestedPage.routeName}/$tabName';
    final event = widget.tracker.tracksPageViews
        ? PageViewEvent(title: title)
        : ScreenView(name: title, id: const Uuid().v4());
    widget.tracker.track(event);
  }
}
