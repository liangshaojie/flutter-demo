import 'package:flutter/material.dart';
import 'package:my_flutter_app/common/component_index.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('CollectionPage'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('CollectionPage'),
      ),
    );
  }
}
