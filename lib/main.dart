import 'package:flutter/material.dart';
import 'package:my_flutter_app/common/component_index.dart';
import 'package:my_flutter_app/ui/pages/page_index.dart';
void main() => runApp(BlocProvider<ApplicationBloc>(
  bloc: ApplicationBloc(),
  child: BlocProvider(child: MyApp(), bloc: MainBloc()),
));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Color _themeColor = Colours.app_main;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: new SplashPage(),
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
    );
  }
}


