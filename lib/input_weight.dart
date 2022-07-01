import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'db/dao/weight_dao.dart';
import 'db/entity/weight.dart';

class InputWeight extends StatefulWidget {
  const InputWeight({Key? key, required this.id, required this.userName})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final int id;
  final String userName;

  @override
  State<InputWeight> createState() => _InputWeightState();
}

class _InputWeightState extends State<InputWeight> {
  int? _id;
  String _weightValue = '';
  bool _isRegistered = false;
  String _displayDateTime = "";
  String _todayWeightData = "";

  DateFormat dfYyyymmdd = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _initThisScreeen();
    debugPrint('InputWeight initState end');
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
        title: Text('体重記録 : ' + widget.userName),
      ),
      body: Container(
          padding: const EdgeInsets.all(50.0),
          child: Column(children: [
            Text(_displayDateTime + ':' + _todayWeightData),
            TextField(
                enabled: true,
                // 入力数
                maxLength: 5,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: const TextStyle(color: Colors.black),
                obscureText: false,
                maxLines: 1,
                onChanged: (String value) {
                  _setWeightValue(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ]),
            ElevatedButton(
                onPressed: () async {
                  String message = _checkInputWeight(_weightValue);
                  if (message.isNotEmpty) {
                    _displayAlert(message);
                    return;
                  } else {
                    DateTime d = DateTime.now();
                    String date = dfYyyymmdd.format(d);
                    bool? resultRegister = await _displayConfirm(
                        '${date} ${_weightValue}Kg 体重を登録しますか？');
                    if (resultRegister!) {
                      if (_isRegistered) {
                        bool? result =
                            await _displayConfirm('今日の体重は入力済みです。上書きしますか？');
                        if (result!) {
                          _updateWeight(_id!, d.year, d.month, d.day,
                              await double.parse(_weightValue));
                        } else {
                          return;
                        }
                      } else {
                        await _addWeight(
                          _id!,
                          d.year,
                          d.month,
                          d.day,
                          double.parse(_weightValue),
                        );
                      }

                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text("記録"))
          ])),
    );
  }

  _setWeightValue(String value) async {
    setState(() {
      _weightValue = value;
    });
  }

  _addWeight(int id, int year, int month, int day, double weightValue) async {
    await WeightDao.createWeight(id, year, month, day, weightValue);
  }

  _initThisScreeen() async {
    DateTime d = DateTime.now();
    var list = await _searchWeight(_id!, d.year, d.month, d.day);
    setState(() {
      if (list.isNotEmpty) {
        _isRegistered = true;
        _todayWeightData = list[0].weight.toString() + 'Kg';
      } else {
        _todayWeightData = '記録なし';
      }
      _displayDateTime = dfYyyymmdd.format(d);
    });
  }

  Future<List<Weight>> _searchWeight(int id, int year, int month, int day) {
    return WeightDao.getWeightByDay(id, year, month, day);
  }

  _updateWeight(
      int id, int year, int month, int day, double weightValue) async {
    await WeightDao.updateWeight(id, year, month, day, weightValue);
  }

  String _checkInputWeight(String value) {
    try {
      if (value.isEmpty) {
        return '体重の数値が入力されていません。';
      }
      double.parse(value);
      return '';
    } catch (e) {
      return '体重が数値で入力されていません。';
    }
  }

  Future<bool?> _displayConfirm(String message) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('確認'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );
  }

  _displayAlert(String message) {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('エラー'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
