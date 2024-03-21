import 'package:flutter/material.dart';
import 'package:frontend/api/test_html.dart';

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: request(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
              appBar: AppBar(), body: Center(child: Text(snapshot.data!)));
        }
      },
    );
  }
}
