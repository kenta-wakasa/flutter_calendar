import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyCalendar(),
    );
  }
}

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

extension _IntExs on int {
  String toWeek() {
    switch (this) {
      case DateTime.monday:
        return '月';
      case DateTime.tuesday:
        return '火';
      case DateTime.wednesday:
        return '水';
      case DateTime.thursday:
        return '木';
      case DateTime.friday:
        return '金';
      case DateTime.saturday:
        return '土';
      case DateTime.sunday:
        return '日';
      default:
        return '';
    }
  }
}

class _MyCalendarState extends State<MyCalendar> {
  var calendars = <List<DateTime>>[];

  static const gray = Color.fromRGBO(130, 136, 157, 1);

  /// 開始日と終了日までのカレンダーデータを生成する
  List<List<DateTime>> generateCalendar({required DateTime startDay, required DateTime endDay}) {
    assert(startDay.compareTo(endDay) == -1);
    final calendars = <List<DateTime>>[];

    var index = 0;
    var month = <DateTime>[];
    while (startDay.add(Duration(days: index)).compareTo(endDay) == -1) {
      month.add(startDay.add(Duration(days: index)));
      index++;
      // 月が異なった場合、今までのデータを一度カレンダーに格納し、monthを初期化する
      if (month.last.month != startDay.add(Duration(days: index)).month) {
        calendars.add(month);
        month = <DateTime>[];
      }
    }

    return calendars;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      calendars = generateCalendar(startDay: DateTime(2020), endDay: DateTime(2021));
    });

    print(calendars);
  }

  @override
  Widget build(BuildContext context) {
    const cellWidth = 20.0;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: calendars.map((calendar) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: calendar.length * cellWidth,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border(
                        top: const BorderSide(color: gray, width: .5),
                        right: BorderSide(color: gray.withOpacity(.2), width: .5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          '${calendar.first.year}年${calendar.first.month}月',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 19, 80, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: calendar.map(
                      (e) {
                        return Container(
                          width: cellWidth,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: const BorderSide(color: gray, width: .5),
                              vertical: BorderSide(color: gray.withOpacity(.2), width: .5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${e.day}',
                                style: const TextStyle(fontSize: 12, color: gray),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                e.weekday.toWeek(),
                                style: const TextStyle(fontSize: 10, color: gray),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
