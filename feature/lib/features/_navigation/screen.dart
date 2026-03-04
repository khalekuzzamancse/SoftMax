import 'package:feature/features/_navigation/pages_example.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          RouteDelegateImpl.of(context).push(DetailsScreenConfig("Home"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
class DetailsScreenView extends StatelessWidget {
  final String from;
  const DetailsScreenView({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('Details Screen:$from'),
      ),
    );
  }
}

