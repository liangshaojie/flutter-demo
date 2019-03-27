import 'package:flutter/material.dart';
import 'package:my_flutter_app/common/component_index.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
  bloc: ApplicationBloc(),
  child: BlocProvider(
      child: MyApp(),
      bloc: MainBloc()
  ),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(AppConfig.version);
    return MaterialApp(
      title: 'Jspang Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('listview widget'),
        ),
        body: ListView(
          children: <Widget>[
            Image.network(
                'http://jspang.com/static/upload/20181111/G-wj-ZQuocWlYOHM6MT2Hbh5.jpg'
            ),
            new Image.network(
                'http://jspang.com/static/myimg/smile-vue.jpg'
            )
          ],
        ),
      ),
    );
  }
}