import 'package:feature/core/core_language.dart';
import 'package:feature/features/_navigation/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Navigation2Sample extends StatefulWidget {
  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<Navigation2Sample> {
  final delegate = RouteDelegateImpl();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser: _RouteParser(),
    );
  }
}

class RouteDelegateImpl extends RouterDelegate<ScreenConfig> with PopNavigatorRouterDelegateMixin<ScreenConfig>, ChangeNotifier {
  final _stack = <ScreenConfig>[];
  @override
  ScreenConfig get currentConfiguration => _stack.isNotEmpty ? _stack.last :HomeScreenConfig();
  static RouteDelegateImpl of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is RouteDelegateImpl, 'Delegate type must match');
    return delegate as RouteDelegateImpl;
  }

  RouteDelegateImpl();
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void push(ScreenConfig newRoute) {
    _stack.add(newRoute);
    notifyListeners();
  }
  @override
  Future<void> setInitialRoutePath(ScreenConfig configuration) {
    return setNewRoutePath(configuration);
  }
  @override
  Future<void> setNewRoutePath(ScreenConfig configuration) {
    _stack
      ..clear()
      ..add(configuration);
    notifyListeners();
    return SynchronousFuture<void>(null);
  }
  @override
  Widget build(BuildContext context) {
    final pages=_stack.map(_toPage).toList(growable: false);
    return Scaffold(
      bottomNavigationBar: Text("Bottom Section"),
      body: Navigator(
        key: navigatorKey,
        onPopPage: _onPopPage,
        pages:pages,
      ),
    );
  }
  Page _toPage(ScreenConfig s) {
    if(s is HomeScreenConfig){
      return MaterialPage(
        key: const ValueKey('home'),
        child: HomeScreenView(),
      );
    }
    else if( s is DetailsScreenConfig){
     return   MaterialPage(
        key: const ValueKey('details'),
        child:  DetailsScreenView(from:s.from),
      );

    }
    else{
      return MaterialPage(
        key: ValueKey(s.path),
        name: s.path,
        child: const Scaffold(body: Center(child: Text('Unknown'))),
      );
    }
  }
  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      _stack.removeAt(_stack.length - 1);
      notifyListeners();
    }
    return route.didPop(result);
  }
}

class _RouteParser extends RouteInformationParser<ScreenConfig> {
  @override
  Future<ScreenConfig> parseRouteInformation(RouteInformation routeInformation) {
    final path = routeInformation.uri.path;
    final normalized = (path.isEmpty) ? '/' : path;
    Logger.on('_RouteParser.parseRouteInformation', 'path:$path');
    switch (normalized) {
      case '/':
        return SynchronousFuture(HomeScreenConfig());
      case '/details':
        return SynchronousFuture(DetailsScreenConfig("Details"));
      default:
        return SynchronousFuture(HomeScreenConfig());
    }
  }
  @override
  RouteInformation restoreRouteInformation(ScreenConfig configuration) {
    Logger.on('_RouteParser.restoreRouteInformation', 'configuration:${configuration.name}');
    return RouteInformation(uri:Uri.parse(configuration.path));
  }
}
abstract interface class ScreenConfig{String get path; String get name;}
final class HomeScreenConfig extends ScreenConfig{
  @override
  String get path =>'/';
  @override
  String get name => "Home";
}
final class DetailsScreenConfig extends ScreenConfig{
  final String from;
  DetailsScreenConfig(this.from);
  @override
  String get path =>'/details';
  @override
  String get name => "Details";
}