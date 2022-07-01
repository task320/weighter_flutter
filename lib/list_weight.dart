import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'db/dao/weight_dao.dart';
import 'db/entity/weight.dart';
import 'dto/item_year_month.dart';
import 'input_weight.dart';

class ListWeight extends StatefulWidget {
  const ListWeight({Key? key, required this.userName, required this.id})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String userName;
  final int id;

  @override
  State<ListWeight> createState() => _ListWeightState();
}

class _ListWeightState extends State<ListWeight> with RouteAware {
  int? _id;
  List<ItemYearMonth> _listYearMonth = <ItemYearMonth>[];
  List<Weight> _weightList = <Weight>[];
  String _selectedItem = '';

  NumberFormat nf = NumberFormat("0.0");
  NumberFormat nf2digit = NumberFormat("00");
  DateFormat dfyyyymmdd = DateFormat('yyyy/MM/dd');

  List<PopupMenuEntry<String>> _popupMenuitems = <PopupMenuEntry<String>>[];

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _updateDisplay();
    debugPrint('ListWeight initState end');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('記録一覧 : ' + widget.userName),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Row(
                children: [
                  Icon(
                    Icons.expand_more,
                    size: 20,
                  ),
                  Text(_selectedItem),
                ],
              ),
              iconSize: 90,
              onSelected: (String yearMonth) {
                setState(() {
                  _selectedItem = yearMonth;
                  List<String> splitYearMonth = yearMonth.split('/');
                  _getWeightByMonth(int.parse(splitYearMonth[0]),
                      int.parse(splitYearMonth[1]));
                });
              },
              itemBuilder: (BuildContext context) => getPopupMenuItems(context),
            ),
          ],
        ),
        body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _weightList.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                    child: ListTile(
                        title: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                          child: Text(
                        nf2digit.format(_weightList[index].day) + '日',
                      )),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          child: Text(
                        nf.format(_weightList[index].weight) + 'Kg',
                      )),
                    ),
                  ],
                )));
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        InputWeight(id: _id!, userName: widget.userName)))
                .then((_) => _updateDisplay());
          },
          tooltip: '体重記録',
          child: const Icon(Icons.add),
        ));
  }

  _updateDisplay() {
    DateTime d = DateTime.now();
    _getInputYearMonth(d.year, d.month);
    _getWeightByMonth(d.year, d.month);
  }

  _getInputYearMonth(int nowYear, int nowMonth) {
    WeightDao.getInputYearMonth(_id!).then((list) {
      _listYearMonth = list;
      if (_listYearMonth.length > 0) {
        _selectedItem = _listYearMonth[0].getYearSlashMonth();
      } else {
        _listYearMonth.add(ItemYearMonth(nowYear, nowMonth));
        _selectedItem = _listYearMonth[0].getYearSlashMonth();
      }
      _setPopupMenuItem();
    });
  }

  _getWeightByMonth(int year, int month) {
    WeightDao.getWeightByMonth(_id!, year, month).then((list) {
      setState(() {
        _weightList = list;
      });
    });
  }

  List<PopupMenuEntry<String>> getPopupMenuItems(BuildContext contenct) {
    return _popupMenuitems;
  }

  void _setPopupMenuItem() {
    setState(() {
      _popupMenuitems = <PopupMenuEntry<String>>[];
      for (ItemYearMonth item in _listYearMonth) {
        String yearSlashMonth = item.getYearSlashMonth();
        _popupMenuitems.add(
            PopupMenuItem(child: Text(yearSlashMonth), value: yearSlashMonth));
      }
    });
  }
}
