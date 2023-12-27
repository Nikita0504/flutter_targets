// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trenning/models/target_info.dart';
import 'package:trenning/notifications/notifications.dart';
import 'package:trenning/showModalBottomSheet/hours.dart';
import 'package:trenning/showModalBottomSheet/minutes.dart';
import 'package:trenning/showModalBottomSheet/model.dart';
import 'package:trenning/showModalBottomSheet/seconds.dart';

const List<String> list = ['Create', 'History', 'Account'];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? uid;
  late String name;
  late String userTarget;
  TargetInfo targetInfo = TargetInfo('', 0, '');
  String sumTarget = '0';
  String? firstTarget;

  HMS hms = HMS('00', '00', '00');

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    NotificationModel.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          iconTheme: Theme.of(context).iconTheme,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/settings', (route) => true);
            },
          ),
          actions: [
            DropdownButton<String>(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.primary,
              ),
              underline: const SizedBox(),
              style: Theme.of(context).primaryTextTheme.displayLarge,
              onChanged: (String? value) {
                setState(() {
                  if (value == 'History') {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/history', (route) => true);
                  } else if (value == 'Create') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        titleTextStyle: Theme.of(context)
                            .primaryTextTheme
                            .displayLarge!
                            .copyWith(fontSize: 20),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        title: const Text('Creat your target'),
                        content: TextField(
                          onChanged: (value) {
                            userTarget = value;
                          },
                          decoration:
                              const InputDecoration(hintText: 'Your target'),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                TargetInfo targetInfo =
                                    TargetInfo(userTarget, 0, userTarget);
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(uid)
                                    .update({
                                  '${targetInfo.firstName}.target':
                                      targetInfo.target,
                                  '${targetInfo.firstName}.balance':
                                      targetInfo.balance
                                }).catchError((error) {
                                  print("Error adding document: $error");
                                });
                                userTarget = '';
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (value == 'Account') {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/accountScreen', (route) => true);
                  }
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (snapshot.hasData) {
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;
              return ListView.builder(
                itemCount: data?.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  data!.remove('profileData');
                  if (data != null && index < data.keys.length) {
                    var key = data.keys.elementAt(index);
                    var dataMap = data[key];
                    return Dismissible(
                      key: Key(key),
                      child: Card(
                        child: Column(children: [
                          ListTile(
                            title: Text(
                              'target:  ${dataMap['target']}',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 16),
                            ),
                            subtitle: Text('balance: ${dataMap['balance']}'),
                          ),
                          Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                              TextButton(
                                child: const Text('Rename'),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      titleTextStyle: Theme.of(context)
                                          .primaryTextTheme
                                          .displayLarge!
                                          .copyWith(fontSize: 20),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      title: const Text('Rename target'),
                                      content: TextField(
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Rename target'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: Text('Cancel',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displayLarge!
                                                  .copyWith(fontSize: 14)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(uid)
                                                .update({
                                              '${key}.target': name,
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displayLarge!
                                                  .copyWith(fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                              TextButton(
                                child: const Text('Add'),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      titleTextStyle: Theme.of(context)
                                          .primaryTextTheme
                                          .displayLarge!
                                          .copyWith(fontSize: 20),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      title: const Text('Add to target'),
                                      content: TextField(
                                        onChanged: (value) {
                                          sumTarget = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: ' Add to target'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: Text('Cancel',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displayLarge!
                                                  .copyWith(fontSize: 14)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            targetInfo.setBalanse(
                                                int.parse(sumTarget),
                                                dataMap['balance']);
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(uid)
                                                .update({
                                              '${key}.balance':
                                                  targetInfo.balance
                                            });
                                            sumTarget = '0';
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .displayLarge!
                                                  .copyWith(fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                              TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                            onSelectedItemChanged:
                                                                (value) {
                                                              setState(() {
                                                                hms.hours = value
                                                                    .toString();
                                                              });
                                                            },
                                                            perspective: 0.01,
                                                            diameterRatio: 1,
                                                            itemExtent: 50,
                                                            physics:
                                                                const FixedExtentScrollPhysics(),
                                                            childDelegate:
                                                                ListWheelChildBuilderDelegate(
                                                                    childCount:
                                                                        25,
                                                                    builder:
                                                                        (context,
                                                                            index) {
                                                                      return Hours(
                                                                        hours:
                                                                            index,
                                                                      );
                                                                    })),
                                                  ),
                                                  Expanded(
                                                      child: ListWheelScrollView
                                                          .useDelegate(
                                                              onSelectedItemChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  hms.minutes =
                                                                      value
                                                                          .toString();
                                                                });
                                                              },
                                                              physics:
                                                                  const FixedExtentScrollPhysics(),
                                                              perspective: 0.01,
                                                              diameterRatio: 1,
                                                              itemExtent: 50,
                                                              childDelegate:
                                                                  ListWheelChildBuilderDelegate(
                                                                      childCount:
                                                                          61,
                                                                      builder:
                                                                          (context,
                                                                              index) {
                                                                        return Minutes(
                                                                          minutes:
                                                                              index,
                                                                        );
                                                                      }))),
                                                  Expanded(
                                                    child: ListWheelScrollView
                                                        .useDelegate(
                                                            onSelectedItemChanged:
                                                                (value) {
                                                              setState(() {
                                                                hms.seconds = value
                                                                    .toString();
                                                              });
                                                            },
                                                            physics:
                                                                const FixedExtentScrollPhysics(),
                                                            perspective: 0.01,
                                                            diameterRatio: 1,
                                                            itemExtent: 50,
                                                            childDelegate:
                                                                ListWheelChildBuilderDelegate(
                                                                    childCount:
                                                                        61,
                                                                    builder:
                                                                        (context,
                                                                            index) {
                                                                      return Seconds(
                                                                        seconds:
                                                                            index,
                                                                      );
                                                                    })),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        print(
                                                            '${hms.hours} H ${hms.minutes} M ${hms.seconds} S');

                                                        NotificationModel
                                                            .showBigTextNotification(
                                                                title:
                                                                    'Hi!!!!!!!!!',
                                                                body:
                                                                    '${hms.hours} H ${hms.minutes} M ${hms.seconds} S',
                                                                fln:
                                                                    flutterLocalNotificationsPlugin);
                                                      },
                                                      child: const Text(
                                                          'Save your reminder'))
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text('Reminder',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .displayLarge!
                                          .copyWith(fontSize: 14)))
                            ],
                          )
                        ]),
                      ),
                      onDismissed: (direction) {
                        String listName = '${data.keys.elementAt(index)}';
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .update({'$listName': FieldValue.delete()});
                      },
                    );
                  }
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
