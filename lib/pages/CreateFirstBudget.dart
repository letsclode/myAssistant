import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myassistant1/main.dart';
import 'package:myassistant1/pages/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myassistant1/process/PersistData.dart';
import 'package:myassistant1/variables/global.dart';
import 'package:page_transition/page_transition.dart';

class CreateInitBudgetPage extends StatefulWidget {
  @override
  _initBudget createState() => new _initBudget();
}

class _initBudget extends State<CreateInitBudgetPage> {
  TextEditingController budgetName = new TextEditingController();
  TextEditingController iniBudget = new TextEditingController();

  void initState() {
    super.initState();
    readData(context);
  }

  _createBudget() async {
    final respo = await http
        .post("http://myassistant.ohm-conception.com/api/budget", body: {
      "name": budgetName.text,
      "initial_budget": iniBudget.text,
      "first_day_period": "$_date",
      "period_type": perId.toString(),
      "purpose": _selectedOption,
      "currency_id": currId.toString(),
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      "Accept": "application/json"
    });
    
    print(respo.statusCode);
    if (respo.statusCode == 200 || respo.statusCode == 201) {
      json.encode(respo.body);
      Fluttertoast.showToast(msg: "NEW BUDGET ADDED");
    } else {
      print(respo.statusCode);
      var res = json.decode(respo.body);
      Fluttertoast.showToast(msg: "$res");
    }
  }

  List<String> _currency = ["Euro", "U.S. Dollar"];
  List<String> _period = [
    'Weekly',
    'Monthly',
    'One-off',
    'Trimester',
    'Semester'
  ];
  List<String> _purpose = [
    'Start new Period from previous',
    'Start new Period'
  ];
  int perId = 2;
  int currId = 1;
  String _selectedPeriod = "Monthly";
  String _selectedCurrency = 'Euro';
  String _selectedOption = "Start new Period";
  var _date = (DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(155, 121, 255, 1),
              Color.fromRGBO(155, 121, 255, 0.9),
              Color.fromRGBO(155, 121, 255, 0.5)
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    "CREATE BUDGET",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  height: MediaQuery.of(context).size.height - 140,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                'BUDGET NAME',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: EdgeInsets.only(left: 20),
                              alignment: AlignmentDirectional.centerStart,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: TextField(
                                controller: budgetName,
                                style: TextStyle(
                                    color: Color.fromRGBO(155, 121, 255, 1)),
                                decoration: InputDecoration.collapsed(
                                    hintText: "Required Field",
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(
                                            155, 121, 255, 0.6))),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 30,
                                    child: Text(
                                      'INITIAL BUDGET',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    padding: EdgeInsets.only(left: 20),
                                    alignment: AlignmentDirectional.centerStart,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextField(
                                      controller: iniBudget,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontFamily: "Mont",
                                          color:
                                              Color.fromRGBO(155, 121, 255, 1)),
                                      decoration: InputDecoration.collapsed(
                                          hintText: "0.00",
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  155, 121, 255, 0.5))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 55,
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 30,
                                    child: Text(
                                      'CURRENCY',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Icon(
                                          Icons.expand_more,
                                          color:
                                              Color.fromRGBO(155, 121, 255, 1),
                                        ),
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                155, 121, 255, 1),
                                            fontSize: 17),
                                        isExpanded: true,
                                        hint: Text("Choose your option"),
                                        value: _selectedCurrency,
                                        onChanged: (newCurr) {
                                          setState(() {
                                            _selectedCurrency = newCurr;
                                            if (newCurr == "Euro") {
                                              currId = 1;
                                            } else {
                                              currId = 2;
                                            }
                                          });
                                          print(currId.toString());
                                        },
                                        items: _currency.map((String currency) {
                                          return DropdownMenuItem<String>(
                                            child: Text(currency),
                                            value: currency,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                'FIRST DAY OF YOUR PERIOD',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                padding: EdgeInsets.only(left: 20),
                                alignment: AlignmentDirectional.centerStart,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 280,
                                      height: 50,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        _date,
                                        style: TextStyle(
                                            fontFamily: "Mont",
                                            color: Color.fromRGBO(
                                                155, 121, 255, 1)),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: AlignmentDirectional.center,
                                      child: IconButton(
                                        onPressed: () {
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 1, 1),
                                              maxTime: DateTime.now(),
                                              onChanged: (date) {
                                            print("Change $date");
                                          }, onConfirm: (date) {
                                            setState(() {
                                              // _date = DateFormat("yyyy-MM-dd")
                                              //     .format(date);
                                              _date = (date.year.toString() +
                                                  "-" +
                                                  date.month.toString() +
                                                  "-" +
                                                  date.day.toString());
                                            });
                                            print(_date);
                                          });
                                        },
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.calendar_today,
                                          color:
                                              Color.fromRGBO(155, 121, 255, 1),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                "PERIOD TYPE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: Color.fromRGBO(155, 121, 255, 1),
                                  ),
                                  style: TextStyle(
                                      color: Color.fromRGBO(155, 121, 255, 1),
                                      fontSize: 17),
                                  isExpanded: true,
                                  value: _selectedPeriod,
                                  hint: Text("Select an option"),
                                  items: _period.map((String period) {
                                    return DropdownMenuItem<String>(
                                      child: Text(period),
                                      value: period,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedPeriod = val;
                                      if (val == 'Weekly') {
                                        perId = 1;
                                      } else if (val == 'Monthly') {
                                        perId = 2;
                                      } else if (val == 'One-off') {
                                        perId = 3;
                                      } else if (val == 'Trimester') {
                                        perId = 4;
                                      } else {
                                        perId = 5;
                                      }
                                    });
                                    print(perId.toString());
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Text(
                                "What will you do with the money at the end of the period?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: Color.fromRGBO(155, 121, 255, 1),
                                  ),
                                  style: TextStyle(
                                      color: Color.fromRGBO(155, 121, 255, 1),
                                      fontSize: 17),
                                  isExpanded: true,
                                  value: _selectedOption,
                                  hint: Text("Select an option"),
                                  items: _purpose.map((String val) {
                                    return DropdownMenuItem<String>(
                                      child: Text(
                                        val,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                155, 121, 255, 1)),
                                      ),
                                      value: val,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedOption = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _createBudget();
                          Navigator.push(
                              context,
                              new PageTransition(
                                  child: HomePage(),
                                  type: PageTransitionType.fade));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            'START',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(155, 121, 255, 1),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
