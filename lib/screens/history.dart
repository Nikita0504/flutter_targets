import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}
class _HistoryListState extends State<HistoryList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('History', style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 20),),
      ),
      
    );
  }
}