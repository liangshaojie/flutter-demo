import 'package:flutter/material.dart';
//import 'package:my_flutter_app/demos/index.dart';
import 'package:my_flutter_app/utils/navigator_util.dart';
import 'package:my_flutter_app/utils/util_index.dart';

import './stream_demo.dart';

class ItemModel {
  String title;
  Widget page;

  ItemModel(this.title, this.page);
}

class MainDemosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainDemosPageState();
  }
}

class MainDemosPageState extends State<MainDemosPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter demo"),
        centerTitle: true,
      ),
      body:Center(
        child: BlocDemo(),
      )
    );
  }
}
