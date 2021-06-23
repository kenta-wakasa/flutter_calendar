import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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

  final LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();

  late ScrollController verticalController1;
  late ScrollController verticalController2;

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
    verticalController1 = _controllers.addAndGet();
    verticalController2 = _controllers.addAndGet();
  }

  @override
  void dispose() {
    verticalController1.dispose();
    verticalController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cellWidth = 20.0;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: verticalController2,
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 800,
                child: Column(
                  children: [
                    SizedBox(height: 64 + 32),
                    Container(
                      width: 400,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border(
                          top: const BorderSide(color: gray, width: .5),
                          bottom: const BorderSide(color: gray, width: .5),
                        ),
                      ),
                      child: Text('足場工事'),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  /// 月日表示
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: calendars.map((calendar) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 月表示
                          Container(
                            width: calendar.length * cellWidth,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border(
                                top: const BorderSide(color: gray, width: .5),
                                right: BorderSide(color: gray.withOpacity(.2), width: .5),
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
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

                          /// 日付
                          Row(
                            children: [
                              ...calendar.map(
                                (date) {
                                  return Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: cellWidth,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: const BorderSide(color: gray, width: .5),
                                                bottom: const BorderSide(color: gray, width: .5),
                                                left: BorderSide(color: gray.withOpacity(.5), width: .5),
                                              ),
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${date.day}',
                                                  style: const TextStyle(fontSize: 12, color: gray),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  date.weekday.toWeek(),
                                                  style: const TextStyle(fontSize: 10, color: gray),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (date.day == 1)
                                            SizedBox(
                                              height: 40,
                                              width: 0,
                                              child: DottedLine(
                                                direction: Axis.vertical,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: verticalController1,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: calendars.map((calendar) {
                          return Column(
                            children: [
                              Row(
                                children: calendar.map(
                                  (date) {
                                    return Row(
                                      children: [
                                        if (date.day == 1)
                                          SizedBox(
                                            height: 800,
                                            width: 0,
                                            child: DottedLine(
                                              direction: Axis.vertical,
                                            ),
                                          ),
                                        Container(
                                          width: cellWidth,
                                          height: 800,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(color: gray.withOpacity(.5), width: .5),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 32,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 8,
                                                      width: 8,
                                                      color: Colors.amber,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
