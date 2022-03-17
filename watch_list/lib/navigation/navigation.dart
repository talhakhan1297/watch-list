import 'package:flutter/material.dart';
import 'package:watch_list/view/detail_view.dart';
import 'package:watch_list/view/home_view.dart';

class KRouteInformationParser
    extends RouteInformationParser<List<RouteSettings>> {
  const KRouteInformationParser();

  @override
  Future<List<RouteSettings>> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/')]);
    }
    final routeSettings = uri.pathSegments
        .map((pathSegment) => RouteSettings(
              name: '/$pathSegment',
              arguments: pathSegment == uri.pathSegments.last
                  ? uri.queryParameters
                  : null,
            ))
        .toList();
    return Future.value(routeSettings);
  }

  @override
  RouteInformation restoreRouteInformation(List<RouteSettings> configuration) {
    final location = configuration.last.name;
    final arguments = _restoreArguments(configuration.last);
    return RouteInformation(location: '$location$arguments');
  }

  String _restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.name != '/detail') return '';
    return '?id=${(routeSettings.arguments as Map)['id'].toString()}';
  }
}

class KRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  final _pages = <Page>[];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  void pushPage({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    late Widget child;
    switch (routeSettings.name) {
      case '/detail':
        child =
            DetailView(arg: routeSettings.arguments! as Map<String, String>);
        break;
      case '/':
      default:
        child = HomeView(
          handleTap: (id) => pushPage(
            name: '/detail',
            arguments: {'id': id.toString()},
          ),
        );
        break;
    }
    return MaterialPage(
      child: child,
      key: ValueKey(routeSettings.toString()),
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {
    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());
    return Future.value(null);
  }

  void _setPath(List<Page> pages) {
    _pages.clear();
    _pages.addAll(pages);
    if (_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }
    notifyListeners();
  }
}
