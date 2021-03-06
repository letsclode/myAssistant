import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myassistant1/main.dart';
import 'package:myassistant1/pages/BudgetStatus.dart';
import 'package:myassistant1/variables/global.dart';
import 'package:page_transition/page_transition.dart';

class EditIncome extends StatefulWidget {
  @override
  _editIncomeState createState() => new _editIncomeState();
}

class _editIncomeState extends State<EditIncome> {
  int type = 2;

  _deleteIncome(index) async {
    final res = await http.delete(
        "http://myassistant.ohm-conception.com/api/income_expense/$index",
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token
        });
    if (res.statusCode == 200) {
      json.encode(res.body);
      Fluttertoast.showToast(msg: "Income Deleted Successfully");
    } else {
      Fluttertoast.showToast(
          msg: "Connection Error, Please Try Again ${res.statusCode}");
    }
    _getIncome();
  }

  Future _getIncome() async {
    final response = await http.post(
      "http://myassistant.ohm-conception.com/api/login",
      body: {
        "email": uemail,
        "password": pass,
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        ei_cat = data['success']['details']['incomeexpense_categories'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fd = MediaQuery.of(context);
    return Container(
      width: fd.size.width,
      height: fd.size.height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            width: fd.size.width,
            height: fd.size.height / 12,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "INCOME",
              style: TextStyle(
                  fontSize: fd.size.width / 20, color: Colors.grey.shade700),
            ),
          ),
          FutureBuilder(
            future: _getIncome(),
            builder: (context, result) {
              return Column(
                children: <Widget>[
                  for (var x = 0; x < ei_cat.length; x++)
                    ei_cat[x]['type'] == 2 &&
                            id == ei_cat[x]['user_id'].toString() && budgetId == ei_cat[x]['budget_id'].toString()
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: fd.size.width,
                            height: fd.size.height / 15,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: <Widget>[
                                ei_cat[x]['icon'] == null
                                    ? Container(
                                        width: 20,
                                      )
                                    : Container(
                                        width: fd.size.width / 7,
                                        height: fd.size.height / 15,
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset("${ei_cat[x]['icon']}",color:Color.fromRGBO(155, 121, 255, 1)),
                                      ),
                                Expanded(
                                  child: Container(
                                    child: Text("${ei_cat[x]['name']}".toUpperCase()),
                                  ),
                                ),
                                Container(
                                  width: fd.size.width / 9,
                                  height: fd.size.height / 15,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(155, 121, 255, 1),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _deleteIncome(ei_cat[x]['id']);
                                    // print(payment[x]['id'].toString());
                                    // _deletePayment(payment[x]['id'].toString());
                                  },
                                  child: Container(
                                    width: fd.size.width / 9,
                                    height: fd.size.height / 15,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  Container(
                    width: fd.size.width,
                    height: fd.size.height / 7,
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      width: fd.size.width / 4,
                      height: fd.size.width / 4,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(155, 121, 255, 1),
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            ei_diff = 2;
                          });
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: BudgetStatus(budgetName),
                                  type: PageTransitionType.fade));
                        },
                        icon: Icon(
                          Icons.add,
                          size: fd.size.width / 6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
