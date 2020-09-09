import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/presentation/theme.dart';
import 'package:minimalist/screens/home_screen.dart';
import 'package:minimalist/screens/splash_screen.dart';
import 'package:minimalist/state/app/app_middleware.dart';
import 'package:minimalist/state/app/app_reducer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

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
  runApp(Main(store: store));
}

class MainRoutes {
  static const String home = '/';
  static const String splash = '/splash';
}

class Main extends StatelessWidget {
  final store;

  Main({this.store});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFEEEEEE),
          systemNavigationBarDividerColor: null,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        )
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Burntoast',
        debugShowCheckedModeBanner: false,
        color: Color(0xFFF2993E),
        theme: Burnt.getTheme(context),
        initialRoute: MainRoutes.splash,
        routes: <String, WidgetBuilder>{
          MainRoutes.splash: (context) => SplashScreen(),
          MainRoutes.home: (context) => HomeScreen(),
        },
        builder: (context, child) {
          var currentTsf = MediaQuery.of(context).textScaleFactor;
          var newTsf = -0.25 * currentTsf + 1;
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: newTsf),
          );
        },
      ),
    );
  }
}
