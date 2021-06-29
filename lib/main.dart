import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  String toDayOfTheWeek() {
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
  var months = <List<DateTime>>[];

  final LinkedScrollControllerGroup _verticalControllers = LinkedScrollControllerGroup();
  final LinkedScrollControllerGroup _horizontalControllers = LinkedScrollControllerGroup();

  late ScrollController verticalController1;
  late ScrollController verticalController2;

  late ScrollController horizontalController1;
  late ScrollController horizontalController2;

  static const gray = Color.fromRGBO(130, 136, 157, 1);
  static const defaultTextColor = Color.fromRGBO(0, 19, 80, 1);

  double calenderHeight = 800;

  /// 開始日と終了日までのカレンダーデータを生成する
  List<List<DateTime>> generateCalendar({required DateTime startDay, required DateTime endDay}) {
    assert(startDay.compareTo(endDay) == -1);
    final months = <List<DateTime>>[];

    var index = 0;
    var month = <DateTime>[];
    while (startDay.add(Duration(days: index)).compareTo(endDay) == -1) {
      month.add(startDay.add(Duration(days: index)));
      index++;
      // 月が異なった場合、今までのデータを一度カレンダーに格納し、monthを初期化する
      if (month.last.month != startDay.add(Duration(days: index)).month) {
        months.add(month);
        month = <DateTime>[];
      }
    }

    return months;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      months = generateCalendar(startDay: DateTime(2020), endDay: DateTime(2021));
    });
    verticalController1 = _verticalControllers.addAndGet();
    verticalController2 = _verticalControllers.addAndGet();

    horizontalController1 = _horizontalControllers.addAndGet();
    horizontalController2 = _horizontalControllers.addAndGet();
  }

  @override
  void dispose() {
    verticalController1.dispose();
    verticalController2.dispose();
    horizontalController1.dispose();
    horizontalController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cellWidth = 20.0;

    const tabTextStyle = TextStyle(
      color: defaultTextColor,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '新築仕上げ大工事！',
            style: TextStyle(
              color: defaultTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(44, 93, 255, 1),
                ),
                child: const Text(
                  '公開',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 1,
          // 参考: https://stackoverflow.com/questions/64453159/how-to-use-a-tabbar-in-a-row-flutter
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    const Flexible(
                      flex: 4,
                      child: TabBar(
                        tabs: [
                          Tab(child: Text('表', style: tabTextStyle)),
                          Tab(child: Text('リスト', style: tabTextStyle)),
                          Tab(child: Text('予定', style: tabTextStyle)),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              primary: const Color.fromRGBO(44, 93, 255, 1),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Icon(Icons.unfold_less),
                                Text(
                                  '閉じる',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: horizontalController1,
                    child: Column(
                      children: [
                        const SizedBox(height: 64),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: verticalController1,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: months.map((month) {
                                return Column(
                                  children: [
                                    Row(
                                      children: month.map(
                                        (date) {
                                          return Row(
                                            children: [
                                              if (date.day == 5)
                                                // 工期の破線
                                                SizedBox(
                                                  height: calenderHeight,
                                                  width: 0,
                                                  child: DottedLine(direction: Axis.vertical),
                                                ),
                                              Container(
                                                width: cellWidth,
                                                height: calenderHeight,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: date.day != 5
                                                        ? BorderSide(color: gray.withOpacity(.5), width: .5)
                                                        : BorderSide.none,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    if (date.day == 5)
                                                      SizedBox(
                                                        height: 32,
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            OverflowBox(
                                                              alignment: Alignment.centerLeft,
                                                              maxHeight: 16,
                                                              maxWidth: 32 * 3,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: const [
                                                                  SizedBox(width: 6),
                                                                  Material(
                                                                    shape: BeveledRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                        topRight: Radius.circular(2),
                                                                        bottomRight: Radius.circular(2),
                                                                      ),
                                                                    ),
                                                                    color: Colors.amber,
                                                                    child: SizedBox(height: 6, width: 8),
                                                                  ),
                                                                  SizedBox(width: 5),
                                                                  FittedBox(
                                                                    fit: BoxFit.fitHeight,
                                                                    child: Text(
                                                                      '着工日',
                                                                      style: TextStyle(color: defaultTextColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                  IgnorePointer(
                    ignoring: true,
                    child: SingleChildScrollView(
                      controller: verticalController2,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: calenderHeight,
                        child: Column(
                          children: [
                            SizedBox(height: 64 + 32),
                            Container(
                              width: 400,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(249, 250, 252, 1),
                                border: Border(
                                  top: const BorderSide(color: gray, width: .5),
                                  bottom: const BorderSide(color: gray, width: .5),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(width: 16),
                                    Text(
                                      '足場工事',
                                      style: const TextStyle(
                                        color: defaultTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: horizontalController2,
                      child: Column(
                        children: [
                          /// 月日表示
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: months.map((month) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 月表示
                                  Container(
                                    width: month.length * cellWidth,
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
                                          '${month.first.year}年${month.first.month}月',
                                          style: const TextStyle(
                                            color: defaultTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// 日付
                                  Row(
                                    children: [
                                      ...month.map(
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
                                                        left: date.day != 5
                                                            ? BorderSide(color: gray.withOpacity(.5), width: .5)
                                                            : BorderSide.none,
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
                                                          date.weekday.toDayOfTheWeek(),
                                                          style: const TextStyle(fontSize: 10, color: gray),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (date.day == 5)
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(),
            Container()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
