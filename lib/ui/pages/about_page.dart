import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
              'AboutPage'
          ),
          centerTitle: true,
        ),
        body: Text('AboutPage')
    );
  }
}
