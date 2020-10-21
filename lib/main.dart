import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_middleware.dart';
import 'package:minimalist/state/app/app_reducer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'render/components/common/main_navigator.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(key: 'minimalist'),
    serializer: JsonSerializer<AppState>(AppState.rehydrate),
  );

  var initialState;
  try {
    initialState = await persistor.load();
  } catch (e, stack) {
    print('[ERROR] $e, $stack');
    initialState = null;
  }

  List<Middleware<AppState>> createMiddleware() {
    return <Middleware<AppState>>[
      persistor.createMiddleware(),
      LoggingMiddleware.printer(),
      ...createAppMiddleware(),
    ];
  }

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState(),
    middleware: createMiddleware(),
  );

  var brightness = SchedulerBinding.instance.window.platformBrightness;

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(Themer().getThemeData(brightness)),
      child: Main(store: store),
    ),
  );
}

class MainRoutes {
  static const String home = '/';
}

class Main extends StatefulWidget {
  final Store store;

  Main({this.store});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, int>(
          onInit: (Store<AppState> store) async {
            Themer().init(store.state.settings);
          },
          converter: (Store<AppState> store) => 1,
          builder: (BuildContext context, int props) {
            final themeNotifier = Provider.of<ThemeNotifier>(context);

            return MaterialApp(
              title: 'Burntoast',
              debugShowCheckedModeBanner: false,
              color: Color(0xFFF2993E),
              theme: themeNotifier.getTheme(),
              initialRoute: MainRoutes.home,
              routes: <String, WidgetBuilder>{
                MainRoutes.home: (context) => MainNavigator(),
              },
              builder: (context, child) {
                var currentTsf = MediaQuery.of(context).textScaleFactor;
                var newTsf = -0.25 * currentTsf + 1;
                return MediaQuery(
                  child: child,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: newTsf),
                );
              },
            );
          }
      ),
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
